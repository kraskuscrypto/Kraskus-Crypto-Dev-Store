#!/bin/sh
set -eu

RPC_USER="${KNOTS_RPC_USER:-kraskus}"
: "${KNOTS_RPC_PASSWORD:?KNOTS_RPC_PASSWORD is required}"
WALLET_NAME="${KNOTS_WALLET_NAME:-kraskus-mining}"
SETTLEMENT_WALLET_NAME="${KNOTS_SETTLEMENT_WALLET_NAME:-kraskus-settlement}"

BENEFICIARY_OUT="/runtime/payout_address"
NODE_OUT="/runtime/node_payout_address"
EXTERNAL_OUT="/runtime/external_payout_address"
MODE_FILE="/runtime/native_wallet_enabled"
SETTLEMENT_OUT="/runtime/settlement_address"
ARMED_OUT="/runtime/payout_armed"

rpc() {
  bitcoin-cli -rpcconnect=knots -rpcport=8332 -rpcuser="$RPC_USER" -rpcpassword="$KNOTS_RPC_PASSWORD" "$@"
}

wallet_rpc() {
  wallet="$1"
  shift
  rpc -rpcwallet="$wallet" "$@"
}

wallet_exists() {
  name="$1"
  rpc listwalletdir | grep -Fq "\"name\": \"$name\""
}

wallet_loaded() {
  name="$1"
  rpc listwallets | grep -Fq "\"$name\""
}

ensure_loaded() {
  name="$1"
  if ! wallet_loaded "$name"; then
    echo "Loading wallet: $name"
    rpc loadwallet "$name" >/dev/null
  fi
}

echo "Waiting for Knots RPC..."
i=0
until rpc getblockchaininfo >/dev/null 2>&1; do
  i=$((i+1))
  [ "$i" -lt 120 ] || { echo "Knots RPC did not become ready"; exit 1; }
  sleep 2
done

mkdir -p /runtime

# A pre-settlement install may leave legacy runtime files (payout_address,
# node_payout_address, external_payout_address, native_wallet_enabled)
# owned by an older runtime UID at mode 0644. This process only ever gets
# group access (2000) to /runtime, which is enough to create a new file or
# rename over an existing one (directory write+execute), but NOT enough to
# truncate/overwrite an existing file it does not own in place -- that
# needs the file's own write permission, which 0644 restricts to its
# original owning UID. Re-materialize any such legacy file through a
# temp-file-then-rename so this process becomes its owner before anything
# below writes or chmods it; rename() only requires directory permission,
# so this works regardless of the existing file's ownership.
_reown_if_present() {
  f="$1"
  [ -e "$f" ] || return 0
  tmp="${f}.reown.$$"
  if cat "$f" > "$tmp" 2>/dev/null; then
    # The temp file inherits this process's umask; the adapter and DATUM run
    # as other UIDs and read these files via world-read, so pin 0644 here.
    chmod 644 "$tmp"
    mv -f "$tmp" "$f"
  else
    rm -f "$tmp"
  fi
}
for _legacy in "$BENEFICIARY_OUT" "$NODE_OUT" "$EXTERNAL_OUT" "$MODE_FILE" "$SETTLEMENT_OUT"; do
  _reown_if_present "$_legacy"
done

# Internal settlement wallet: always present. DATUM mines the miner share
# here even before the user configures a beneficiary wallet/address.
if ! wallet_exists "$SETTLEMENT_WALLET_NAME"; then
  echo "Creating internal BTC2b settlement wallet."
  rpc createwallet "$SETTLEMENT_WALLET_NAME" false false "" false true true >/dev/null
else
  ensure_loaded "$SETTLEMENT_WALLET_NAME"
fi
ensure_loaded "$SETTLEMENT_WALLET_NAME"

SETTLEMENT_ADDRESS=""
if [ -s "$SETTLEMENT_OUT" ]; then
  SETTLEMENT_ADDRESS="$(cat "$SETTLEMENT_OUT")"
  INFO="$(wallet_rpc "$SETTLEMENT_WALLET_NAME" getaddressinfo "$SETTLEMENT_ADDRESS" 2>/dev/null || true)"
  printf "%s\n" "$INFO" | grep -Fq "\"ismine\": true" || SETTLEMENT_ADDRESS=""
fi
if [ -z "$SETTLEMENT_ADDRESS" ]; then
  SETTLEMENT_ADDRESS="$(wallet_rpc "$SETTLEMENT_WALLET_NAME" getnewaddress "Kraskus BTC2b Settlement" bech32)"
  printf "%s\n" "$SETTLEMENT_ADDRESS" > "$SETTLEMENT_OUT"
fi
chmod 644 "$SETTLEMENT_OUT"

# User wallet remains explicit. A fresh install has no beneficiary yet, but
# mining is still possible because DATUM uses SETTLEMENT_OUT instead.
if ! wallet_exists "$WALLET_NAME"; then
  echo "No user Knots wallet configured yet; settlement mining is ready."
  rm -f "$BENEFICIARY_OUT" "$NODE_OUT" "$MODE_FILE" "$ARMED_OUT"
  echo "KNOTS_WALLET_INIT=SETTLEMENT_ONLY"
  exit 0
fi

ensure_loaded "$WALLET_NAME"

if [ -s "$NODE_OUT" ]; then
  NODE_ADDRESS="$(cat "$NODE_OUT")"
else
  NODE_ADDRESS="$(wallet_rpc "$WALLET_NAME" getnewaddress "Kraskus Mining" bech32)"
  printf "%s\n" "$NODE_ADDRESS" > "$NODE_OUT"
  chmod 644 "$NODE_OUT"
fi

INFO="$(wallet_rpc "$WALLET_NAME" getaddressinfo "$NODE_ADDRESS")"
printf "%s\n" "$INFO" | grep -Fq "\"ismine\": true" || { echo "Node payout address is not owned by $WALLET_NAME"; exit 1; }

if [ ! -s "$MODE_FILE" ]; then printf "1\n" > "$MODE_FILE"; chmod 644 "$MODE_FILE"; fi
MODE="$(tr "[:upper:]" "[:lower:]" < "$MODE_FILE" | tr -d "[:space:]")"
case "$MODE" in
  0|false|off|no)
    if [ -s "$EXTERNAL_OUT" ]; then BENEFICIARY_ADDRESS="$(cat "$EXTERNAL_OUT")";
    else printf "1\n" > "$MODE_FILE"; BENEFICIARY_ADDRESS="$NODE_ADDRESS"; fi
    ;;
  *) BENEFICIARY_ADDRESS="$NODE_ADDRESS" ;;
esac

printf "%s\n" "$BENEFICIARY_ADDRESS" > "$BENEFICIARY_OUT"
chmod 644 "$BENEFICIARY_OUT" "$NODE_OUT" "$MODE_FILE"
echo "BENEFICIARY_PAYOUT_ADDRESS=$BENEFICIARY_ADDRESS"
echo "KNOTS_WALLET_INIT=PASS"
