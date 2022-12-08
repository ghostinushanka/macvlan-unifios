#!/usr/bin/env bash

set -euo pipefail

RUNNING_FIRMWARE_VERSION="$(ubnt-device-info firmware)"
MODULE_FILE_NAME="${RUNNING_FIRMWARE_VERSION}-macvlan.ko"

RELEASE_TAG="%%GITHUB_TAG%%"

RELEASE_DOWNLOAD_URL_BASE="https://github.com/whi-tw/macvlan-unifi-udr/releases/download/${RELEASE_TAG}"
RELEASE_DOWNLOAD_URL="${RELEASE_DOWNLOAD_URL_BASE}/${MODULE_FILE_NAME}"

DATA_DIR="/data"
MODULE_DIR="${DATA_DIR}/macvlan-module"

mkdir -p "${MODULE_DIR}"

curl -Lo "${MODULE_DIR}/${MODULE_FILE_NAME}" "${RELEASE_DOWNLOAD_URL}" || {
    echo
    echo "****************************************************************************************"
    echo "!! Failed to download module file from ${RELEASE_DOWNLOAD_URL}"
    echo "!! Please check that your firmware version (${RUNNING_FIRMWARE_VERSION}) is supported in release ${RELEASE_TAG}."
    echo "!! Release URL: https://github.com/whi-tw/macvlan-unifi-udr/releases/tag/${RELEASE_TAG}"
    echo "****************************************************************************************"
    exit 1
}

cat <<'EOF' >/data/on_boot.d/01-load-macvlan-module.sh
#!/usr/bin/env bash
set -euo pipefail
RUNNING_FIRMWARE_VERSION="$(ubnt-device-info firmware)"
MODULE_FILE_NAME="${RUNNING_FIRMWARE_VERSION}-macvlan.ko"

insmod /data/macvlan-module/${MODULE_FILE_NAME}
EOF

chmod +x /data/on_boot.d/01-load-macvlan-module.sh
