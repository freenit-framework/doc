#!/bin/sh

BIN_DIR=`dirname $0`
PROJECT_DIR="${BIN_DIR}"
export FREENIT_ENV="devel"
. ${BIN_DIR}/common.sh


setup

mkdocs serve
