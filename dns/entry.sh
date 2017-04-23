#!/usr/bin/env bash
salt-call --local saltutil.sync_states
salt-call --local state.highstate
