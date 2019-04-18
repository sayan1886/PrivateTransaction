# !/bin/bash -e

# assuming the executiong in the root of the project 

source ~/.bashrc

if [ ! -z ${ROOT_PWDS+x} ] ; then 
    echo "Please set ROOT_PWD in Environment Variable with you root password or set in your .bashrc file" 
fi

# Non Optional Parameters
TMP_DIR="/tmp"
PARITY_HOME="/etc/parity"
PARITY_LOG="/var/log/parity"
CWD=$(pwd)
VERBOSE="yes"

if [ "$(uname)" == "Darwin" ]; then
    IP=$(ipconfig getifaddr en0)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    IP=$(hostname -I)
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
#     # Do something under 32 bits Windows NT platform
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
#     # Do something under 64 bits Windows NT platform
fi