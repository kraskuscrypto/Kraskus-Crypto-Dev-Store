# CheetahCoin by Kraskus 0.7.0

Local SOLO and Kraskus PPLNS/SOLO through the same miner host and ports.
Includes schedules, optional local fallback and app-scoped forwarded-worker data.

**Every restart and upgrade starts routing paused. Review your saved mode and
external reward address in Kraskus Pool before resuming.** Local SOLO keeps the
existing developer split; forwarded work pays only the 1% pool fee.

No native wallet is exposed. Back up legacy wallets and move funds to a wallet
you control before upgrading from a native-wallet release. Never purge app data:
legacy wallets, backups, credentials, chain data and external settings are retained.

See [release details](RELEASE-0.7.0.txt) for qualification scope and limitations.
Node and CKPool image pins are unchanged from the preceding Dev Store recipe.
