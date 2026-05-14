import io
import os
import unittest
from contextlib import redirect_stdout

from delete_unused_images import cleanup_registry, determine_dry_run


class FakeRegistryClient:
    def __init__(self, catalog, tags_by_repo, manifests):
        self._catalog = catalog
        self._tags_by_repo = tags_by_repo
        self._manifests = manifests
        self.deleted_manifests = []

    def get_catalog(self):
        return list(self._catalog)

    def get_tags(self, repository):
        return list(self._tags_by_repo.get(repository, []))

    def get_manifest(self, repository, tag):
        return self._manifests[(repository, tag)]

    def delete_manifest(self, repository, digest):
        self.deleted_manifests.append((repository, digest))


class CleanupRegistryTests(unittest.TestCase):
    def setUp(self):
        self.now = _dt('2025-11-04T12:00:00')
        self.old_manifest = _manifest('sha-old', '2025-08-01T00:00:00')
        self.recent_manifest = _manifest('sha-new', '2025-11-01T00:00:00')

    def test_dry_run_lists_candidates_without_deleting(self):
        client = FakeRegistryClient(
            catalog=['sample/repo'],
            tags_by_repo={'sample/repo': ['old', 'new']},
            manifests={
                ('sample/repo', 'old'): self.old_manifest,
                ('sample/repo', 'new'): self.recent_manifest,
            },
        )

        buffer = io.StringIO()
        with redirect_stdout(buffer):
            cleanup_registry(client, self.now, dry_run=True)

        output = buffer.getvalue()
        self.assertIn('Would delete sample/repo:old', output)
        self.assertNotIn('Deleting sample/repo:old', output)
        self.assertEqual([], client.deleted_manifests)

    def test_live_run_deletes_and_confirms(self):
        client = FakeRegistryClient(
            catalog=['sample/repo'],
            tags_by_repo={'sample/repo': ['old']},
            manifests={('sample/repo', 'old'): self.old_manifest},
        )

        buffer = io.StringIO()
        with redirect_stdout(buffer):
            cleanup_registry(client, self.now, dry_run=False)

        output = buffer.getvalue()
        self.assertIn('Deleting sample/repo:old', output)
        self.assertIn('Deleted sample/repo:old', output)
        self.assertEqual([('sample/repo', 'sha-old')], client.deleted_manifests)

    def test_cli_flag_overrides_environment_variable(self):
        os.environ['DRY_RUN'] = 'true'
        try:
            self.assertFalse(determine_dry_run(cli_dry_run=False))
        finally:
            os.environ.pop('DRY_RUN', None)

    def test_cli_flag_enables_dry_run(self):
        os.environ['DRY_RUN'] = 'false'
        try:
            self.assertTrue(determine_dry_run(cli_dry_run=True))
        finally:
            os.environ.pop('DRY_RUN', None)


def _manifest(digest, last_pulled):
    return digest, {
        'history': [
            {
                'v1Compatibility': (
                    '{"last_pulled": "' + last_pulled + '"}'
                )
            }
        ]
    }


def _dt(value):
    from datetime import datetime

    return datetime.fromisoformat(value)


if __name__ == '__main__':
    unittest.main()
