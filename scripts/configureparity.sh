#!/bin/bash -e

VERBOSE="no"

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

PARITY_HOME="/etc/parity"

if [ "$(uname)" == "Darwin" ]; then
    IP=$(ipconfig getifaddr en0)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    IP=$(hostname -I)
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
#     # Do something under 32 bits Windows NT platform
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
#     # Do something under 64 bits Windows NT platform
fi

sudo curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST $IP:8545 | jq '.result' | tr -d '"' >> $PARITY_HOME/peers.list 
sudo curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST $IP:8547 | jq '.result' | tr -d '"' >> $PARITY_HOME/peers.list 
sudo curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST $IP:8549 | jq '.result' | tr -d '"' >> $PARITY_HOME/peers.list 
sudo curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST $IP:8551 | jq '.result' | tr -d '"' >> $PARITY_HOME/peers.list 

curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node1", "node1"],"id":0}' -H "Content-Type: application/json" -X POST $IP:8545
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node2", "node2"],"id":0}' -H "Content-Type: application/json" -X POST $IP:8547
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node3", "node3"],"id":0}' -H "Content-Type: application/json" -X POST $IP:8549
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node4", "node4"],"id":0}' -H "Content-Type: application/json" -X POST $IP:8551

sudo ex -sc 'g/^\s*#/s/#//' -cx $PARITY_HOME/config1.toml
sudo ex -sc 'g/^\s*#/s/#//' -cx $PARITY_HOME/config2.toml
sudo ex -sc 'g/^\s*#/s/#//' -cx $PARITY_HOME/config3.toml
sudo ex -sc 'g/^\s*#/s/#//' -cx $PARITY_HOME/config4.toml

sleep 2

sh ./scripts/stopparity.sh 

sleep 5

sh ./scripts/startparity.sh

