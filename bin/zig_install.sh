#!/bin/bash

set -e

if !(type "zig" > /dev/null 2>&1); then
  if (type "brew" > /dev/null 2>&1); then
    brew install zig
  fi
fi

if !(type "zls" > /dev/null 2>&1); then
  case ${OSTYPE} in
    darwin*)
      download_url="https://github.com/zigtools/zls/releases/download/0.9.0/x86_64-macos.tar.xz"
      ;;
    linux*)
      download_url="https://github.com/zigtools/zls/releases/download/0.9.0/x86_64-linux.tar.xz"
  esac
  mkdir -p /tmp/zls && cd /tmp/zls && curl -L $download_url | tar -xJ --strip-components=1 -C .
  mkdir -p $HOME/.local/bin && mv /tmp/zls/zls $HOME/.local/bin/ && chmod +x $HOME/.local/bin/zls
  rm -rf /tmp/zls
fi
