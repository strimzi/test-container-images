#!/bin/bash

IMAGES_DIR="images"
CONNECTOR_PLUGINS_DIR="$IMAGES_DIR/connector_plugins"

TEST_CONNECTORS_VERSION=$(cat test-connectors.version)

MAVEN_REPO_URL="https://repo1.maven.org/maven2"

GROUP_PATH="io/strimzi/strimzi-test-connectors"
ARTIFACT="distribution"

ZIP="${ARTIFACT}-${TEST_CONNECTORS_VERSION}.zip"
REMOTE_URL="${MAVEN_REPO_URL}/${GROUP_PATH}/${ARTIFACT}/${TEST_CONNECTORS_VERSION}/${ZIP}"

echo "[INFO] Preparing connector plugins directory..."
rm -rf "$CONNECTOR_PLUGINS_DIR"
mkdir -p "$CONNECTOR_PLUGINS_DIR"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "[INFO] Downloading test connectors ${TEST_CONNECTORS_VERSION} from Maven Central..."
echo "[INFO] URL: $REMOTE_URL"
wget -O "$TMP_DIR/$ZIP" "$REMOTE_URL"

echo "[INFO] Extracting connector plugins..."
unzip -q "$TMP_DIR/$ZIP" -d "$CONNECTOR_PLUGINS_DIR"

echo "[INFO] Connector plugins prepared:"
ls -la "$CONNECTOR_PLUGINS_DIR/"