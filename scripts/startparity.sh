#!/bin/bash -e

. ./__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

sh ./scripts/startnode1.sh &
sleep 5

sh ./scripts/startnode2.sh &
sleep 5

sh ./scripts/startnode3.sh &
sleep 5

sh ./scripts/startnode3.sh &
sleep 5