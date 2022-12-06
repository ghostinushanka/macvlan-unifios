#!/usr/bin/env bash

set -euo pipefail

RUNNING_FIRMWARE_VERSION="$(ubnt-device-info firmware)"
MODULE_FILE_NAME="${RUNNING_FIRMWARE_VERSION}-macvlan.ko"

RELEASE_DOWNLOAD_URL_BASE="https://github.com/whi-tw/macvlan-unifios/releases/download/%%GITHUB_TAG%%"
RELEASE_DOWNLOAD_URL="${RELEASE_DOWNLOAD_URL_BASE}/${MODULE_FILE_NAME}"

DATA_DIR="/data"
MODULE_DIR="/data/macvlan-module"

mkdir -p "${MODULE_DIR}"

curl -o "${MODULE_DIR}/${MODULE_FILE_NAME}" "${RELEASE_DOWNLOAD_URL}"

cat <<'EOF'> /data/on_boot.d/01-load-macvlan-module.sh
#!/usr/bin/env bash
set -euo pipefail
RUNNING_FIRMWARE_VERSION="$(ubnt-device-info firmware)"
MODULE_FILE_NAME="${RUNNING_FIRMWARE_VERSION}-macvlan.ko"

insmod /data/macvlan-module/${MODULE_FILE_NAME}
EOF
