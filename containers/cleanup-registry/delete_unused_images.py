#!/usr/bin/env python3
import argparse
import json
import os
from datetime import datetime, timedelta

import requests

REGISTRY_URL = os.getenv('REGISTRY_URL', 'http://localhost:5000')
CLEANUP_OLDER_THAN_DAYS = os.getenv('CLEANUP_OLDER_THAN_DAYS', '30')
TIME_THRESHOLD = timedelta(days=int(CLEANUP_OLDER_THAN_DAYS))
TRUTHY = {'1', 'true', 'yes', 'on'}


class RegistryClient:
    def __init__(self, registry_url=REGISTRY_URL):
        self._registry_url = registry_url.rstrip('/')

    def get_catalog(self):
        response = requests.get(f'{self._registry_url}/v2/_catalog')
        response.raise_for_status()
        return response.json().get('repositories', [])

    def get_tags(self, repository):
        response = requests.get(f'{self._registry_url}/v2/{repository}/tags/list')
        response.raise_for_status()
        return response.json().get('tags', [])

    def get_manifest(self, repository, tag):
        headers = {'Accept': 'application/vnd.docker.distribution.manifest.v2+json'}
        response = requests.get(
            f'{self._registry_url}/v2/{repository}/manifests/{tag}', headers=headers
        )
        response.raise_for_status()
        return response.headers['Docker-Content-Digest'], response.json()

    def delete_manifest(self, repository, digest):
        response = requests.delete(f'{self._registry_url}/v2/{repository}/manifests/{digest}')
        response.raise_for_status()


def parse_args(argv=None):
    parser = argparse.ArgumentParser(description='Cleanup unused container images.')
    dry_run_group = parser.add_mutually_exclusive_group()
    dry_run_group.add_argument(
        '--dry-run', dest='dry_run', action='store_true', help='List candidates without deleting.'
    )
    dry_run_group.add_argument(
        '--no-dry-run',
        dest='dry_run',
        action='store_false',
        help='Force deletion even if DRY_RUN env var is set.',
    )
    parser.set_defaults(dry_run=None)
    return parser.parse_args(argv)


def determine_dry_run(cli_dry_run, env=os.environ):
    if cli_dry_run is not None:
        return cli_dry_run

    env_value = env.get('DRY_RUN')
    if env_value is None:
        return False

    return env_value.strip().lower() in TRUTHY


def cleanup_registry(client, now, dry_run):
    for repository in client.get_catalog():
        for tag in client.get_tags(repository):
            try:
                digest, manifest = client.get_manifest(repository, tag)
            except requests.HTTPError as e:
                print(f'Error fetching manifest for {repository}:{tag} - {e}')
                continue

            last_pulled = _extract_last_pulled(manifest)
            if last_pulled is None:
                print(f'No last_pulled info for {repository}:{tag}, skipping.')
                continue

            if now - last_pulled > TIME_THRESHOLD:
                if dry_run:
                    print(f'Would delete {repository}:{tag} with digest {digest}')
                    continue

                print(f'Deleting {repository}:{tag} with digest {digest}')
                client.delete_manifest(repository, digest)
                print(f'Deleted {repository}:{tag} with digest {digest}')


def _extract_last_pulled(manifest):
    history = manifest.get('history', [])
    if not history:
        return None

    v1_compat = history[0].get('v1Compatibility')
    if v1_compat is None:
        return None

    if isinstance(v1_compat, str):
        try:
            v1_compat = json.loads(v1_compat)
        except json.JSONDecodeError:
            return None

    if not isinstance(v1_compat, dict):
        return None

    last_pulled_raw = v1_compat.get('last_pulled')
    if last_pulled_raw is None:
        return None

    try:
        return datetime.fromisoformat(last_pulled_raw)
    except ValueError:
        return None


def main(argv=None):
    args = parse_args(argv)
    dry_run = determine_dry_run(args.dry_run)
    client = RegistryClient()
    now = datetime.now()

    cleanup_registry(client, now, dry_run)


if __name__ == '__main__':
    main()
