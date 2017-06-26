#!/usr/bin/env bash
kitchen converge && kitchen verify
success=$?
kitchen destroy
exit $success
