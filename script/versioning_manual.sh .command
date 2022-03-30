#! /usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
PROJECT_PATH=$SCRIPT_PATH/../../
cd $PROJECT_PATH

echo ""
read -p "[@] input version number [x.y.z]: " versionNumber
read -p "[@] input build number [number]: " buildNumber
echo ""

if [ -z "$versionNumber" ] || [ -z "$buildNumber" ]; then
    echo "[@] not found"
else 
    echo "[@] running versioning: v$versionNumber($buildNumber)"
    fastlane versioning version_number:$versionNumber build_number:$buildNumber env --rework --verbose
fi

echo ""