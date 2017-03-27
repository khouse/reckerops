#!/usr/bin/env bash
cd ..e
success=$(bundle exec kitchen converge $1)
bundle exec kitchen destroy $1
exit $success
