#! /usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
PROJECT_PATH=$SCRIPT_PATH/../../
cd $PROJECT_PATH

bundle exec fastlane test versioning_mode:build_number use_git_push:true --env rework --verbose
