#!/usr/bin/env bash
cd ..
bundle exec kitchen converge $1
success=$?
bundle exec kitchen destroy $1
exit $success
