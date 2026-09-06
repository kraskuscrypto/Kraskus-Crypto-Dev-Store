#!/bin/sh
set -eu

RPC_USER="${KNOTS_RPC_USER:-kraskus}"
: "${KNOTS_RPC_PASSWORD:?KNOTS_RPC_PASSWORD is required}"
WALLET_NAME="${KNOTS_WALLET_NAME:-kraskus-mining}"

ACTIVE_OUT="/runtime/payout_address"
NODE_OUT="/runtime/node_payout_address"
EXTERNAL_OUT="/runtime/external_payout_address"
MODE_FILE="/runtime/native_wallet_enabled"

rpc() {
  bitcoin-cli -rpcconnect=knots -rpcport=8332 -rpcuser="$RPC_USER" -rpcpassword="$KNOTS_RPC_PASSWORD" "$@"
}

echo "Waiting for Knots RPC..."
i=0
until rpc getblockchaininfo >/dev/null 2>&1; do
  i=$((i+1))
  [ "$i" -lt 120 ] || { echo "Knots RPC did not become ready"; exit 1; }
  sleep 2
done

if ! rpc listwalletdir | grep -Fq "\"name\": \"$WALLET_NAME\""; then
  echo "Creating Knots wallet: $WALLET_NAME"
  rpc -named createwallet wallet_name="$WALLET_NAME" load_on_startup=true >/dev/null
else
  if ! rpc listwallets | grep -Fq "\"$WALLET_NAME\""; then
    echo "Loading existing Knots wallet: $WALLET_NAME"
    rpc loadwallet "$WALLET_NAME" >/dev/null
  fi
fi

mkdir -p /runtime

if [ -s "$NODE_OUT" ]; then
  NODE_ADDRESS="$(cat "$NODE_OUT")"
else
  NODE_ADDRESS="$(rpc -rpcwallet="$WALLET_NAME" getnewaddress "Kraskus Mining" bech32)"
  printf '%s\n' "$NODE_ADDRESS" > "$NODE_OUT"
  chmod 644 "$NODE_OUT"
fi

INFO="$(rpc -rpcwallet="$WALLET_NAME" getaddressinfo "$NODE_ADDRESS")"
printf '%s\n' "$INFO" | grep -Fq '"ismine": true' || {
  echo "Node payout address is not owned by $WALLET_NAME"
  exit 1
}

if [ ! -s "$MODE_FILE" ]; then
  printf '1\n' > "$MODE_FILE"
  chmod 644 "$MODE_FILE"
fi

MODE="$(tr '[:upper:]' '[:lower:]' < "$MODE_FILE" | tr -d '[:space:]')"

case "$MODE" in
  0|false|off|no)
    if [ -s "$EXTERNAL_OUT" ]; then
      ACTIVE_ADDRESS="$(cat "$EXTERNAL_OUT")"
    else
      printf '1\n' > "$MODE_FILE"
      ACTIVE_ADDRESS="$NODE_ADDRESS"
    fi
    ;;
  *)
    ACTIVE_ADDRESS="$NODE_ADDRESS"
    ;;
esac

printf '%s\n' "$ACTIVE_ADDRESS" > "$ACTIVE_OUT"
chmod 644 "$ACTIVE_OUT" "$NODE_OUT" "$MODE_FILE"
echo "ACTIVE_PAYOUT_ADDRESS=$ACTIVE_ADDRESS"
echo "KNOTS_WALLET_INIT=PASS"
