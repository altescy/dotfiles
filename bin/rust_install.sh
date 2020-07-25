#!/bin/bash

curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
source ~/.cargo/env
rustup component add rls rust-analysis rust-src
