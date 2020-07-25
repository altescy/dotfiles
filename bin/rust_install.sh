#!/bin/bash

if !(type "rustup" > /dev/null 2>&1); then
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
    source ~/.cargo/env
fi

rustup component add rls rust-analysis rust-src
