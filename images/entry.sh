#!/usr/bin/env bash
kitchen list
kitchen converge && kitchen verify
kitchen_success=$?
kitchen destroy
exit kitchen_success
