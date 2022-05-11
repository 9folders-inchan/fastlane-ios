#! /usr/bin/env bash

# define script path
SCRIPT_PATH=$(dirname "$0")
# run copy script
$SCRIPT_PATH/setup_copy.sh.command
# define proj path
PROJECT_PATH=$SCRIPT_PATH/../../
# move proj path
cd $PROJECT_PATH
# setup bundle
bundle config set --local path 'vendor/bundle'
bundle install
bundle exec fastlane install_plugins --verbose
bundle exec fastlane update_plugins --verbose
