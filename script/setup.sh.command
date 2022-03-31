#! /usr/bin/env bash


SCRIPT_PATH=$(dirname "$0")
PROJECT_PATH=$SCRIPT_PATH/../../
cd $PROJECT_PATH

bundle install
bundle exec fastlane install_plugins --verbose
bundle exec fastlane update_plugins --verbose