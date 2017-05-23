#!/usr/bin/env bash
set -e
stack_master validate
stack_master diff
stack_master apply --yes
