#!/bin/bash

case ${OSTYPE} in
  darwin*)
    POETRY_HOME="$HOME/Library/Application Support/pypoetry"
    ;;
  linux*)
    POETRY_HOME="$HOME/.config/pypoetry"
    ;;
esac

mkdir -p "$POETRY_HOME"
rm -f "$POETRY_HOME/config.toml"
ln -s "$PWD/poetry/conf.d/config.toml" "$POETRY_HOME/config.toml"
