set -euo pipefail
CURRENT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo rm "/etc/nixos"
sudo ln -s "$CURRENT/NixOS Configuration" "/etc/nixos"
