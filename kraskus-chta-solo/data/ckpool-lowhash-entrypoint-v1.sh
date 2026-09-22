#!/bin/sh
set -eu

BASE_CONFIG="/kraskus-config/ckpool.conf"
LOW_CONFIG="/tmp/ckpool-lowhash.conf"
DIFF="0.002"
CKPOOL_BIN="$(command -v ckpool || true)"
[ -n "$CKPOOL_BIN" ] || CKPOOL_BIN="/bin/ckpool"
CHILD=""
LAST_SIG=""

stop_child() {
  if [ -n "$CHILD" ] && kill -0 "$CHILD" 2>/dev/null; then
    kill -TERM "$CHILD" 2>/dev/null || true
    wait "$CHILD" 2>/dev/null || true
  fi
  CHILD=""
}

payout_configured() {
  [ -s "$BASE_CONFIG" ] || return 1
  value="$(sed -n 's/^[[:space:]]*"btcaddress"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$BASE_CONFIG" | head -n 1)"
  [ -n "$value" ]
}

render_low_config() {
  sed -E \
    -e 's/("mindiff"[[:space:]]*:[[:space:]]*)[-+0-9.eE]+/\10.002/' \
    -e 's/("startdiff"[[:space:]]*:[[:space:]]*)[-+0-9.eE]+/\10.002/' \
    "$BASE_CONFIG" > "$LOW_CONFIG.tmp"
  mv "$LOW_CONFIG.tmp" "$LOW_CONFIG"
}

config_sig() {
  cksum "$BASE_CONFIG" 2>/dev/null | awk '{print $1 ":" $2}' || true
}

start_child() {
  payout_configured || {
    echo "[chta-lowhash] Payout not configured; low-hash CKPool remains stopped"
    return 2
  }
  render_low_config
  mkdir -p /www /www/pool /www/users
  chmod 0755 /www /www/pool /www/users 2>/dev/null || true
  echo "[chta-lowhash] Starting fractional CKPool at minimum difficulty ${DIFF}"
  "$CKPOOL_BIN" -L -c "$LOW_CONFIG" &
  CHILD=$!
  sleep 1
  if ! kill -0 "$CHILD" 2>/dev/null; then
    wait "$CHILD" 2>/dev/null || true
    CHILD=""
    echo "[chta-lowhash] CKPool failed to start"
    return 1
  fi
}

reload_if_changed() {
  sig="$(config_sig)"
  [ -n "$sig" ] || return 0
  if [ "$sig" != "$LAST_SIG" ]; then
    LAST_SIG="$sig"
    stop_child
    start_child || true
  fi
}

trap 'stop_child; exit 0' TERM INT HUP

echo "[chta-lowhash] Supervisor started"
while [ ! -s "$BASE_CONFIG" ]; do sleep 1; done
LAST_SIG="$(config_sig)"
start_child || true

while :; do
  reload_if_changed
  if [ -n "$CHILD" ] && ! kill -0 "$CHILD" 2>/dev/null; then
    wait "$CHILD" 2>/dev/null || true
    CHILD=""
    echo "[chta-lowhash] CKPool exited"
  fi
  sleep 1
done
