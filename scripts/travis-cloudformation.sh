#!/usr/bin/env bash
cd $TRAVIS_BUILD_DIR/cloudformation
bundle exec stack_master validate && bundle exec stack_master apply --yes
