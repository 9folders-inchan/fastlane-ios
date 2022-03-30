#! /usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
PROJECT_PATH=$SCRIPT_PATH/../../
cd $PROJECT_PATH

fastlane release versioning_mode:none --env rework --verbose