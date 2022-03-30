#! /usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
PROJECT_PATH=$SCRIPT_PATH/../../
cd $PROJECT_PATH

echo ""
echo "[@] Versioning Bump"
echo "- 1. Patch	// 1.0.0(2) -> 1.0.1(1)"
echo "- 2. Minor	// 1.0.0(2) -> 1.1.0(1)"
echo "- 3. Major	// 1.0.0(2) -> 2.0.0(1)"
echo "- 4. Build Number // 1.0.0(2) -> 1.0.0(3)"
echo ""
read -p "[@] Select Number: " selectedNumber
echo ""
if [ 0 -lt $selectedNumber ] || [$selectedNumber -lt 5]; then
    versioningElements=("Patch" "Minor" "Major" "Build_Number")
    versioningMode=${versioningElements[$selectedNumber-1]}
    echo "[@] selected $versioningMode ... gogo"
    fastlane versioning versioning_mode:$versioningMode env --rework --verbose
else 
    echo "[@] not found"
fi

echo ""