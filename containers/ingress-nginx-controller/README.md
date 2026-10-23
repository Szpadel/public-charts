# ingress-nginx compatibility build

This image retains ingress-nginx for systems that cannot migrate yet.
[Upstream retired in March 2026](https://kubernetes.io/blog/2026/01/29/ingress-nginx-statement/).
Upstream no longer provides security updates.

## Local security changes

The version pins are in `Dockerfile`.

- The nginx override replaces the upstream nginx version.
- The ModSecurity override replaces the upstream library version. See the
  [ModSecurity security fixes](https://github.com/owasp-modsecurity/ModSecurity/blob/v3.0.16/CHANGES).
- The controller build updates Go modules with security fixes. The module pins
  and advisory links are in `Dockerfile`.
- The njs override includes the security fixes in its
  [release history](https://nginx.org/en/docs/njs/changes.html).
- The OpenTelemetry override includes the fix for
  [CVE-2026-44967](https://github.com/open-telemetry/opentelemetry-cpp/security/advisories/GHSA-5qhm-4rfp-qqvj).
  The protobuf definitions are updated with the SDK.
- The local logging patch replaces upstream patch 19. It preserves nginx's
  log-buffer checks and the `log_escape_non_ascii` directive.

When you change nginx, check every upstream patch. A successful patch application
does not establish compatibility. Build both targets. Run the logging test.

## Local validation

Run these commands from the repository root:

```sh
image_version=$(cat containers/ingress-nginx-controller/VERSION)
docker build --target controller --build-arg IMAGE_VERSION="$image_version" -t local/ingress-nginx-controller containers/ingress-nginx-controller
docker build --target controller-chroot --build-arg IMAGE_VERSION="$image_version" -t local/ingress-nginx-controller-chroot containers/ingress-nginx-controller
python3 containers/ingress-nginx-controller/test_log_escaping.py local/ingress-nginx-controller
python3 containers/ingress-nginx-controller/test_log_escaping.py --chroot local/ingress-nginx-controller-chroot
```

The logging test loads the njs and telemetry modules and sends local HTTP requests.
It checks default, enabled, disabled, and inherited escaping. It uses no host ports
or mounted directories.
The chroot test starts nginx directly as root. It does not exercise the controller's
`unshare` wrapper or establish Kubernetes compatibility.

Scan both complete images before release. For example, with Trivy installed:

```sh
trivy image --image-src docker --scanners vuln local/ingress-nginx-controller
trivy image --image-src docker --scanners vuln local/ingress-nginx-controller-chroot
```

A scan covers only the components and advisories that the scanner recognizes.
The chroot's copied system libraries have no APK database. Its image scan does not
inventory those libraries. The standard image scan covers the shared base packages.
Review source-built modules separately. A clean scan does not prove that an image
has no vulnerabilities.
