#!/usr/bin/env python3
"""Packaging regression: BTC2b wallet-init must survive the 5tratumOS updater.

The updater merges Store data/ into an existing app-state data/ with
`cp -an`, which never overwrites existing files. A stale data/wallet-init.sh
from an older install would therefore shadow a changed script. The compose
must mount a versioned filename that a stale install cannot already have.
"""
import hashlib
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import yaml

APP = Path(__file__).resolve().parents[1] / "kraskus-btc-blake2b-solo"
LEGACY_NAME = "wallet-init.sh"
STALE_BODY = b"#!/bin/sh\n# stale legacy wallet-init (pre-settlement)\nexit 2\n"


def mounted_wallet_init_source():
    compose = yaml.safe_load((APP / "docker-compose.yml").read_text())
    vols = compose["services"]["wallet-init"]["volumes"]
    for v in vols:
        if v.endswith(":/usr/local/bin/wallet-init:ro"):
            return v.split(":", 1)[0]
    raise AssertionError("wallet-init script mount not found")


class UpdateSafe(unittest.TestCase):
    def test_compose_mounts_versioned_script_from_data_dir(self):
        src = mounted_wallet_init_source()
        prefix = "${APP_DATA_DIR}/data/"
        self.assertTrue(src.startswith(prefix), src)
        name = src[len(prefix):]
        self.assertNotEqual(name, LEGACY_NAME)
        self.assertRegex(name, r"^wallet-init-settlement-v\d+\.sh$")
        self.assertTrue((APP / "data" / name).is_file())

    def test_no_active_mount_of_legacy_script(self):
        text = (APP / "docker-compose.yml").read_text()
        self.assertNotIn("data/wallet-init.sh", text)

    def test_versioned_script_is_settlement_contract(self):
        name = mounted_wallet_init_source().rsplit("/", 1)[1]
        body = (APP / "data" / name).read_text()
        self.assertIn('SETTLEMENT_OUT="/runtime/settlement_address"', body)
        self.assertIn("KNOTS_WALLET_INIT=SETTLEMENT_ONLY", body)
        self.assertIn("_reown_if_present()", body)

    @unittest.skipUnless(shutil.which("bash") and shutil.which("cp"), "needs bash/cp")
    def test_cp_an_upgrade_adds_versioned_script_despite_stale_legacy(self):
        name = mounted_wallet_init_source().rsplit("/", 1)[1]
        with tempfile.TemporaryDirectory() as tmp:
            state = Path(tmp) / "state" / "data"
            state.mkdir(parents=True)
            (state / LEGACY_NAME).write_bytes(STALE_BODY)
            # Exactly the updater's merge step.
            subprocess.run(
                ["cp", "-an", f"{(APP / 'data').as_posix()}/.", f"{state.as_posix()}/"],
                check=True,
            )
            # cp -an never clobbers the stale file (why versioning is needed)...
            self.assertEqual((state / LEGACY_NAME).read_bytes(), STALE_BODY)
            # ...but the versioned file is added and is what compose mounts.
            added = state / name
            self.assertTrue(added.is_file())
            self.assertEqual(
                hashlib.sha256(added.read_bytes()).hexdigest(),
                hashlib.sha256((APP / "data" / name).read_bytes()).hexdigest(),
            )
            self.assertNotEqual(added.read_bytes(), STALE_BODY)
            # Second update pass stays idempotent.
            subprocess.run(
                ["cp", "-an", f"{(APP / 'data').as_posix()}/.", f"{state.as_posix()}/"],
                check=True,
            )
            self.assertEqual(
                hashlib.sha256(added.read_bytes()).hexdigest(),
                hashlib.sha256((APP / "data" / name).read_bytes()).hexdigest(),
            )


if __name__ == "__main__":
    sys.exit(unittest.main(verbosity=2))
