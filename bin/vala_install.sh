#!/bin/bash

if !(type "valac" > /dev/null 2>&1); then
  case ${OSTYPE} in
    darwin*)
      brew install vala
      ;;
    linux*)
      if (type "apt-get" > /dev/null 2>&1); then
        sudo apt-get install -y valac
      fi
      ;;
  esac
fi

valac --version
