#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

echo ${ROOT_PWD} | sudo -S pkill -f parity

echo ${ROOT_PWD} | sudo -S kill -9 $(ps aux | grep parity | awk '{print $2}')

echo ${ROOT_PWD} | sudo -S rm -rf ${PARITY_HOME}
echo ${ROOT_PWD} | sudo -S rm -rf ${PARITY_LOG}