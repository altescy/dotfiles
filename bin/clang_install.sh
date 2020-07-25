#!/bin/bash

if !(type "clang" > /dev/null 2>&1); then
  case ${OSTYPE} in
    darwin*)
      brew install llvm
      ;;
    linux*)
      if (type "apt-get" > /dev/null 2>&1); then
        sudo apt-get install -y clang clang-tools
      fi
      ;;
  esac
fi

clang --version
