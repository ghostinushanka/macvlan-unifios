#!/usr/bin/env bash

RUNNING_FIRMWARE_VERSION="$(ubnt-device-info firmware)"

DATA_DIR="/data"
MODULE_DIR="/data/macvlan-module"

mkdir -p "${MODULE_DIR}"

pushd ${MODULE_DIR}
