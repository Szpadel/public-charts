#!/usr/bin/env python3
"""Check the patched nginx log directive in a locally built controller image.

Run with: python3 test_log_escaping.py <image>
Docker must be available. The test uses no host ports or mounted directories.
"""

import argparse
import json
import subprocess
import time


def docker(*arguments):
    """Run Docker and return stdout. Command failures stop the test."""
    return subprocess.check_output(
        ["docker", *arguments], text=True, stderr=subprocess.STDOUT,
    ).rstrip("\n")


def main():
    """Verify default, enabled, disabled, and inherited escaping on real requests."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image")
    parser.add_argument("--chroot", action="store_true", help="Test a controller-chroot image.")
    arguments = parser.parse_args()
    configuration = """
load_module /etc/nginx/modules/ngx_http_js_module.so;
load_module /etc/nginx/modules/otel_ngx_module.so;
pid /tmp/nginx-test.pid;
error_log stderr notice;
events {}
http {
    log_format probe '$http_x_probe';
    access_log /tmp/probe.log probe;
    server {
        listen 8080;
        location /default { return 200 'ok'; }
        location /on { log_escape_non_ascii on; return 200 'ok'; }
        location /off { log_escape_non_ascii off; return 200 'ok'; }
        location /inherit {
            log_escape_non_ascii off;
            location /inherit/child { return 200 'ok'; }
        }
    }
}
"""
    prefix = ""
    run_options = ["run", "-d", "--network", "none"]
    nginx_command = "/usr/local/nginx/sbin/nginx"
    if arguments.chroot:
        # The test starts nginx directly. The production controller performs its own chroot operation.
        prefix = "/chroot"
        run_options.extend(["--user", "0"])
        nginx_command = f"chroot /chroot {nginx_command}"
    container = docker(
        *run_options, "--entrypoint", "sh", arguments.image,
        "-ec", f'printf %s "$1" > {prefix}/tmp/log-test.conf; '
        f'exec {nginx_command} -c /tmp/log-test.conf -g "daemon off;"',
        "sh", configuration,
    )
    try:
        for attempt in range(30):
            result = subprocess.run(
                ["docker", "exec", container, "wget", "-qO-", "http://127.0.0.1:8080/default"],
                capture_output=True,
            )
            if result.returncode == 0:
                break
            time.sleep(1)
        else:
            raise AssertionError(docker("logs", container))

        log_path = f"{prefix}/tmp/probe.log"
        assert docker("exec", container, "tail", "-n", "1", log_path) == "-"

        # The original directive escapes high bytes by default, but preserves ASCII escaping in both modes.
        probe = 'café "\\'
        escaped = r'caf\xC3\xA9 \x22\x5C'
        unescaped = 'café ' + r'\x22\x5C'
        for path, expected in (
            ("/default", escaped), ("/off", unescaped), ("/on", escaped),
            ("/inherit/child", unescaped), ("/on", escaped),
        ):
            docker("exec", container, "wget", "-qO-", "--header", f"X-Probe: {probe}",
                   f"http://127.0.0.1:8080{path}")
            actual = docker("exec", container, "tail", "-n", "1", log_path)
            assert actual == expected, (path, actual, expected)

        errors = docker("logs", container)
        assert "no buffer space in log script copy" not in errors, errors
        print(json.dumps({"log_escaping": "passed", "image": arguments.image}))
    finally:
        docker("rm", "-f", container)


if __name__ == "__main__":
    main()
