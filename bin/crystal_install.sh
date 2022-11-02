#!/bin/bash

set -e

if !(type "crystal" > /dev/null 2>&1); then
  if (type "brew" > /dev/null 2>&1); then
    brew install crystal
  fi
fi

if !(type "crystalline" > /dev/null 2>&1); then
  case ${OSTYPE} in
    darwin*)
      download_url="https://github.com/elbywan/crystalline/releases/latest/download/crystalline_x86_64-apple-darwin.gz"
      ;;
    linux*)
      download_url="https://github.com/elbywan/crystalline/releases/latest/download/crystalline_x86_64-unknown-linux-gnu.gz -O crystalline.gz"
  esac
  mkdir -p /tmp/crystalline && cd /tmp/crystalline && curl -L $download_url -o crystalline.gz && gzip -d crystalline.gz
  mkdir -p $HOME/.local/bin && mv /tmp/crystalline/crystalline $HOME/.local/bin/ && chmod u+x $HOME/.local/bin/crystalline
  rm -rf /tmp/crystalline
fi
