#! /usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
PROJECT_PATH=$SCRIPT_PATH/../../
cd $PROJECT_PATH

bundle exec fastlane test versioning_mode:patch gitBranch:refs/heads/test/fastlaneSwift --env rework --verbose
