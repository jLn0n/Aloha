#!/bin/bash
LUNE_URL="https://github.com/lune-org/lune/releases/download/v0.8.9/lune-0.8.9-linux-x86_64.zip"

LUNE_ZIP_PATH="./lune-0.8.9-linux-x86_64.zip"
LUNE_EXTRACT_PATH="./"

echo "Downloading Lune from $LUNE_URL..."
curl -L -o $LUNE_ZIP_PATH $LUNE_URL

echo "Unzipping Lune..."
unzip -o $LUNE_ZIP_PATH -d $LUNE_EXTRACT_PATH

rm $LUNE_ZIP_PATH
echo "Lune has been downloaded and unzipped to $LUNE_EXTRACT_PATH."

echo "Running 'lune setup'..."
./lune setup

echo "Do you want to move the executable to /usr/local/bin for global access? (y/n)"
read -r MOVE_TO_BIN

if [[ "$MOVE_TO_BIN" == "y" ]]; then
  sudo mv "$LUNE_EXTRACT_PATH/lune" /usr/local/bin/lune
  echo "Executables moved to /usr/local/bin. You can now run 'lune' globally."
else
  echo "Installation complete. Executables remain in $LUNE_EXTRACT_PATH."
fi