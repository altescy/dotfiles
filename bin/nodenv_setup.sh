#!/bin/bash

anyenv install nodenv
exec $SHELL -l

# Install latest node
NODE_VERSION=nodenv install -l | grep -E '^[0-9]+\.[0-9]+\.[0-9]$' | tail -n 1
yes | nodenv install $NODE_VERSION
nodenv rehash
nodenv global $NODE_VERSION
exec $SHELL -l
