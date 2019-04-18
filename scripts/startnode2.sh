#!/bin/bash -e

. ./__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

# Start node2
echo ${ROOT_PWD} | sudo -S parity --config ${PARITY_HOME}/config2.toml --rpccorsdomain "*" --jsonrpc-cors null