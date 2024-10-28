#!/bin/bash

LUNE_URL="https://github.com/lune-org/lune/releases/download/v0.8.9/lune-0.8.9-linux-x86_64.zip"
STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-linux-x86_64.zip"

LUNE_ZIP_PATH="./lune-0.8.9-linux-x86_64.zip"
STYLUA_ZIP_PATH="./stylua-linux-x86_64.zip"
LUNE_EXTRACT_PATH="./"
STYLUA_EXTRACT_PATH="./"

echo "Downloading Lune from $LUNE_URL..."
curl -L -o $LUNE_ZIP_PATH $LUNE_URL

echo "Unzipping Lune..."
unzip -o $LUNE_ZIP_PATH -d $LUNE_EXTRACT_PATH

rm $LUNE_ZIP_PATH
echo "Lune has been downloaded and unzipped to $LUNE_EXTRACT_PATH."

echo "Running 'lune setup'..."
./lune setup

echo "Downloading StyLua from $STYLUA_URL..."
curl -L -o $STYLUA_ZIP_PATH $STYLUA_URL

echo "Unzipping StyLua..."
unzip -o $STYLUA_ZIP_PATH -d $STYLUA_EXTRACT_PATH

rm $STYLUA_ZIP_PATH
echo "StyLua has been downloaded and unzipped to $STYLUA_EXTRACT_PATH."

echo "Do you want to move the executables to /usr/local/bin for global access? (y/n)"
read -r MOVE_TO_BIN

if [[ "$MOVE_TO_BIN" == "y" ]]; then
  sudo mv "$LUNE_EXTRACT_PATH/lune" /usr/local/bin/lune
  sudo mv "$STYLUA_EXTRACT_PATH/stylua" /usr/local/bin/stylua
  echo "Executables moved to /usr/local/bin. You can now run 'lune' and 'stylua' globally."
else
  echo "Installation complete. Executables remain in $LUNE_EXTRACT_PATH and $STYLUA_EXTRACT_PATH."
fi