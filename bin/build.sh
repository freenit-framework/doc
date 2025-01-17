#!/bin/sh

BIN_DIR=`dirname $0`
PROJECT_DIR="${BIN_DIR}"
export FREENIT_ENV="build"
. ${BIN_DIR}/common.sh


setup

mkdocs build
