#!/usr/bin/env python3
import requests
import sys
import os
from datetime import datetime, timedelta

REGISTRY_URL = os.getenv('REGISTRY_URL', 'http://localhost:5000')
CLEANUP_OLDER_THAN_DAYS=os.getenv('CLEANUP_OLDER_THAN_DAYS', '30')
TIME_THRESHOLD = timedelta(days=int(CLEANUP_OLDER_THAN_DAYS))

def get_catalog():
    response = requests.get(f'{REGISTRY_URL}/v2/_catalog')
    response.raise_for_status()
    return response.json()['repositories']

def get_tags(repository):
    response = requests.get(f'{REGISTRY_URL}/v2/{repository}/tags/list')
    response.raise_for_status()
    return response.json()['tags']

def get_manifest(repository, tag):
    headers = {'Accept': 'application/vnd.docker.distribution.manifest.v2+json'}
    response = requests.get(f'{REGISTRY_URL}/v2/{repository}/manifests/{tag}', headers=headers)
    response.raise_for_status()
    return response.headers['Docker-Content-Digest'], response.json()

def delete_manifest(repository, digest):
    response = requests.delete(f'{REGISTRY_URL}/v2/{repository}/manifests/{digest}')
    response.raise_for_status()

def main():
    now = datetime.now()

    for repository in get_catalog():
        for tag in get_tags(repository):
            digest, manifest = get_manifest(repository, tag)
            last_pulled = datetime.fromisoformat(manifest['history'][0]['v1Compatibility']['last_pulled'])

            if now - last_pulled > TIME_THRESHOLD:
                print(f'Deleting {repository}:{tag} with digest {digest}')
                delete_manifest(repository, digest)

if __name__ == '__main__':
    main()
