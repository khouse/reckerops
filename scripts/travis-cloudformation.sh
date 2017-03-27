#!/usr/bin/env bash
cd ../cloudformation/
bundle exec stack_master validate && bundle exec stack_master apply --yes
