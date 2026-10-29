set -euo pipefail
CURRENT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo rm -r "/etc/nixos"
sudo ln -s "$CURRENT/nixos" "/etc/nixos"
