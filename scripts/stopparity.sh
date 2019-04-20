#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

echo ${ROOT_PWD} | sudo -S pkill -f parity

sleep 5

echo ${ROOT_PWD} | sudo -S kill -9 $(ps aux | grep parity | awk '{print $2}')