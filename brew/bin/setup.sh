#!/bin/bash

case ${OSTYPE} in
  darwin*)
    ;;
  linux*)
    echo 'eval $($HOME/.linuxbrew/bin/brew shellenv)' >> $HOME/.bash_profile
    ;;
esac
