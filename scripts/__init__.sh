# !/bin/bash -e

# assuming the executiong in the root of the project 

if [ ! -z ${ROOT_PWDS+x} ] ; then 
    echo "Please set ROOT_PWD in Environment Variable with you root password" 
fi

# Non Optional Parameters

PARITY_HOME="/etc/parity"
PARITY_LOG="/var/log/parity"
CWD=$(pwd)
VERBOSE="yes"