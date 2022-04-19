#!/bin/bash

set -e

if !(type "valac" > /dev/null 2>&1); then
  case ${OSTYPE} in
    darwin*)
      brew install vala vala-language-server
      ;;
    linux*)
      if (type "apt-get" > /dev/null 2>&1); then
        sudo apt-get install -y valac vala-language-server
      fi
      ;;
  esac
fi

valac --version
