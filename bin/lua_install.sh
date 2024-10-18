#!/bin/bash

if !(type "stylua" > /dev/null 2>&1); then
  case ${OSTYPE} in
    darwin*)
      brew install stylua
      ;;
    linux*)
      ;;
  esac
fi
