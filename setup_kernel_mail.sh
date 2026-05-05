#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NOSUDO=1
source "$SCRIPT_DIR/utils.sh"

if ! command -v lei >/dev/null 2>&1; then
	echo "lei not found in PATH." >&2
	exit 1
fi

if ! command -v aerc >/dev/null 2>&1; then
	echo "aerc not found in PATH." >&2
	exit 1
fi

EMAIL="$(git config --global --get user.email || true)"
if [[ -z "$EMAIL" ]]; then
	read -rp "Enter email address for aerc From header: " EMAIL
fi

if [[ -z "$EMAIL" ]]; then
	echo "Email is required." >&2
	exit 1
fi

AERC_DIR="$XDG_CONFIG_HOME/aerc"
MAIL_ROOT="$HOME/mail/kernel"

echo "[$(date '+%H:%M:%S')] ==> Creating kernel maildirs..."
mkdir -p "$MAIL_ROOT"

echo "[$(date '+%H:%M:%S')] ==> Writing aerc accounts config..."
mkdir -p "$AERC_DIR"
cat >"$AERC_DIR/accounts.conf" <<EOF
[kernel]
source = maildir://$MAIL_ROOT
default = staging
from = Samiul Islam <$EMAIL>
EOF
chmod 600 "$AERC_DIR/accounts.conf"

echo "[$(date '+%H:%M:%S')] ==> Fetching linux-staging..."
lei q -o "$MAIL_ROOT/staging" -I https://lore.kernel.org/all \
	'l:linux-staging.lists.linux.dev AND rt:35.days.ago..'

echo "[$(date '+%H:%M:%S')] ==> Fetching kernel-janitors..."
lei q -o "$MAIL_ROOT/janitors" -I https://lore.kernel.org/all \
	'l:kernel-janitors.vger.kernel.org AND rt:35.days.ago..'

echo "[$(date '+%H:%M:%S')] ==> Fetching kernelnewbies..."
lei q -o "$MAIL_ROOT/kernelnewbies" -I https://lore.kernel.org/all \
	'l:kernelnewbies.kernelnewbies.org AND rt:35.days.ago..'

echo "[$(date '+%H:%M:%S')] ==> Fetching lkml skim..."
lei q -o "$MAIL_ROOT/lkml" -I https://lore.kernel.org/all \
	'l:linux-kernel.vger.kernel.org AND rt:1.day.ago..'

echo
echo "[$(date '+%H:%M:%S')] ==> Kernel mail setup complete."
echo "Refresh with: lei up --all"
