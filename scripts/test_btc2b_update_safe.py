#!/usr/bin/env python3
"""Packaging regression: BTC2b 0.2.x must stay safe to update in place.

0.2.0 retired the 0.1.x wallet-init sidecar and its data/ scripts. The
updater merges Store data/ into app state with `cp -an` (never overwrites),
so the package must not reintroduce host-mounted scripts a stale install
could shadow. It must also keep the long Knots stop grace that protects the
chain database, keep the images pinned by digest and keep the 1923 Stratum
port without publishing the retired 23334.
"""
import re
import sys
import unittest
from pathlib import Path

import yaml

APP = Path(__file__).resolve().parents[1] / "kraskus-btc-blake2b-solo"
DIGEST = re.compile(r"^ghcr\.io/kraskuscrypto/kraskus-5trat-btc-blake2b-[a-z]+:\d+\.\d+\.\d+@sha256:[0-9a-f]{64}$")


def compose():
    return yaml.safe_load((APP / "docker-compose.yml").read_text())


def grace_seconds(value):
    m = re.fullmatch(r"(?:(\d+)m)?(?:(\d+)s)?", str(value or ""))
    return int(m.group(1) or 0) * 60 + int(m.group(2) or 0) if m and value else 0


class UpdateSafe(unittest.TestCase):
    def test_no_wallet_init_sidecar_or_data_scripts(self):
        self.assertNotIn("wallet-init", compose()["services"])
        self.assertFalse((APP / "data").exists())
        self.assertNotIn("/data/wallet-init", (APP / "docker-compose.yml").read_text())

    def test_knots_stop_grace_protects_chainstate(self):
        self.assertGreaterEqual(grace_seconds(compose()["services"]["knots"].get("stop_grace_period")), 600)

    def test_release_images_pinned_by_digest(self):
        for name, svc in compose()["services"].items():
            image = svc.get("image", "")
            if "btc-blake2b" in image:
                self.assertRegex(image, DIGEST, name)

    def test_stratum_1923_and_no_legacy_port(self):
        ports = [str(p) for svc in compose()["services"].values() for p in svc.get("ports", [])]
        self.assertTrue(any(p.split(":")[0] == "1923" for p in ports), ports)
        self.assertFalse(any("23334" in p for p in ports), ports)

    def test_versions_agree(self):
        app = yaml.safe_load((APP / "5tratstore-app.yml").read_text())
        review = yaml.safe_load((APP / "5tratstore-review.yml").read_text())
        self.assertRegex(str(app["version"]), r"^\d+\.\d+\.\d+$")
        self.assertEqual(str(app["version"]), str(review["appVersion"]))
        for svc in compose()["services"].values():
            image = svc.get("image", "")
            if "btc-blake2b" in image:
                self.assertIn(f":{app['version']}@", image)


if __name__ == "__main__":
    sys.exit(unittest.main(verbosity=2))
