#!/usr/bin/env bash
kitchen list
kitchen converge
converge_success=$?
kitchen destroy
exit converge_success
