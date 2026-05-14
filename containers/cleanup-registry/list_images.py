#!/usr/bin/env python3
import argparse
import os
from typing import Optional, Sequence

import requests

from delete_unused_images import REGISTRY_URL, RegistryClient


def parse_args(argv=None):
    parser = argparse.ArgumentParser(description='List container images and their tag counts.')
    parser.add_argument(
        '--registry-url',
        dest='registry_url',
        help='Registry URL to query; defaults to REGISTRY_URL env var or the cleanup script default.',
    )
    return parser.parse_args(argv)


def determine_registry_url(cli_registry_url: Optional[str], env=os.environ) -> str:
    if cli_registry_url:
        return cli_registry_url

    env_value = env.get('REGISTRY_URL')
    if env_value:
        return env_value

    return REGISTRY_URL


def format_count(repository: str, tags: Optional[Sequence[str]]) -> str:
    tag_count = len(tags or [])
    suffix = 'tag' if tag_count == 1 else 'tags'
    return f'{repository}: {tag_count} {suffix}'


def list_images(client: RegistryClient) -> None:
    for repository in client.get_catalog():
        try:
            tags = client.get_tags(repository)
        except requests.RequestException as exc:
            print(f'Error fetching tags for {repository} - {exc}')
            continue

        print(format_count(repository, tags))


def main(argv=None) -> None:
    args = parse_args(argv)
    registry_url = determine_registry_url(args.registry_url)
    client = RegistryClient(registry_url=registry_url)
    list_images(client)


if __name__ == '__main__':
    main()
