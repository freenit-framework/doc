#!/bin/sh


export BIN_DIR=`dirname $0`
export PROJECT_ROOT="${BIN_DIR}/.."
export VIRTUALENV=${VIRTUALENV:="freenit"}
export SYSPKG=${SYSPKG:="no"}
export SYSPKG=`echo ${SYSPKG} | tr '[:lower:]' '[:upper:]'`
export PIP_INSTALL="pip install -U --upgrade-strategy eager"
export OFFLINE=${OFFLINE:="no"}


setup() {
  cd ${PROJECT_ROOT}
  if [ "${SYSPKG}" != "YES" ]; then
    if [ ! -d ${HOME}/.virtualenvs/${VIRTUALENV} ]; then
        python${PY_VERSION} -m venv "${HOME}/.virtualenvs/${VIRTUALENV}"
    fi
    . ${HOME}/.virtualenvs/${VIRTUALENV}/bin/activate
    if [ "${OFFLINE}" != "yes" ]; then
      ${PIP_INSTALL} pip wheel freenit[doc]
    fi
  fi
}
