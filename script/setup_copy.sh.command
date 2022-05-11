#! /usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
SRC_PATH=$SCRIPT_PATH/../
cd $SRC_PATH

echo ""
echo "[@] Initailize Fastlane Path: $PWD"
echo ""
FILE_NAMES=(".env" ".env.rework" "Gemfile")
echo "[@] Copying... required file [${FILE_NAMES[@]}]"
echo ""

for file_name in "${FILE_NAMES[@]}"; do
    cp -R ./"resources"/$file_name ..
done
