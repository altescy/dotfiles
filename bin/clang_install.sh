#!/bin/bash

if !(type "clang" > /dev/null 2>&1); then
  case ${OSTYPE} in
    darwin*)
      brew install llvm
      ;;
    linux*)
      if (type "apt-get" > /dev/null 2>&1); then
        sudo apt-get install -y clang-10 clang-tools-10 clangd-10
        sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 1000
        sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-10 1000
        sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-10 1000
      fi
      ;;
  esac
fi

clang --version
