#!/bin/bash

set -e

config_dir="$HOME/.config/efm-langserver"

mkdir -p $config_dir
ln -s $(pwd)/efm/conf.d/config.yaml $config_dir/config.yaml
