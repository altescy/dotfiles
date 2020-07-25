#!/bin/bash

yes | anyenv install --init
exec $SHELL -l
