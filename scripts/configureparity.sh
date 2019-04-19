#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

echo ${ROOT_PWD} | sudo -S curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${IP}:8545 | jq '.result' | tr -d '"' >> ${PARITY_HOME}/peers.list 
echo ${ROOT_PWD} | sudo -S curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${IP}:8547 | jq '.result' | tr -d '"' >> ${PARITY_HOME}/peers.list 
echo ${ROOT_PWD} | sudo -S curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${IP}:8549 | jq '.result' | tr -d '"' >> ${PARITY_HOME}/peers.list 
echo ${ROOT_PWD} | sudo -S curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${IP}:8551 | jq '.result' | tr -d '"' >> ${PARITY_HOME}/peers.list 

SIGNER_NODE1=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node1", "node1"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8545 | jq '.result')
SIGNER_NODE2=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node2", "node2"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8547 | jq '.result')
SIGNER_NODE3=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node3", "node3"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8549 | jq '.result')
SIGNER_NODE4=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node4", "node4"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8551 | jq '.result')

if [ "$(uname)" == "Darwin" ]; then

    sed -i '' 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE1}']/g'  ${PARITY_HOME}/node1.toml
    sed -i '' 's/^#author = \"\"/author = '${SIGNER_NODE1}'/g'  ${PARITY_HOME}/node1.toml
    sed -i '' 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE1}'/g'  ${PARITY_HOME}/node1.toml

    sed -i '' 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE2}']/g'  ${PARITY_HOME}/node2.toml
    sed -i '' 's/^#author = \"\"/author = '${SIGNER_NODE2}'/g'  ${PARITY_HOME}/node2.toml
    sed -i '' 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE2}'/g'  ${PARITY_HOME}/node2.toml

    sed -i '' 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE3}']/g'  ${PARITY_HOME}/node3.toml
    sed -i '' 's/^#author = \"\"/author = '${SIGNER_NODE3}'/g'  ${PARITY_HOME}/node3.toml
    sed -i '' 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE3}'/g'  ${PARITY_HOME}/node3.toml

    sed -i '' 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE4}']/g'  ${PARITY_HOME}/node4.toml
    sed -i '' 's/^#author = \"\"/author = '${SIGNER_NODE4}'/g'  ${PARITY_HOME}/node4.toml
    sed -i '' 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE4}'/g'  ${PARITY_HOME}/node4.toml

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    
    sed -i 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE1}']/g'  ${PARITY_HOME}/node1.toml
    sed -i 's/^#author = \"\"/author = '${SIGNER_NODE1}'/g'  ${PARITY_HOME}/node1.toml
    sed -i 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE1}'/g'  ${PARITY_HOME}/node1.toml

    sed -i 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE2}']/g'  ${PARITY_HOME}/node2.toml
    sed -i 's/^#author = \"\"/author = '${SIGNER_NODE2}'/g'  ${PARITY_HOME}/node2.toml
    sed -i 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE2}/'g'  ${PARITY_HOME}/node2.toml

    sed -i 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE3}']/g'  ${PARITY_HOME}/node3.toml
    sed -i 's/^#author = \"\"/author = '${SIGNER_NODE3}'/g'  ${PARITY_HOME}/node3.toml
    sed -i 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE3}'/g'  ${PARITY_HOME}/node3.toml

    sed -i 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE4}']/g'  ${PARITY_HOME}/node4.toml
    sed -i 's/^#author = \"\"/author = '${SIGNER_NODE4}'/g'  ${PARITY_HOME}/node4.toml
    sed -i 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE4}'/g'  ${PARITY_HOME}/node4.toml
    
fi

sleep 2

sh ${CWD}/scripts/add_validator.sh

sleep 2

sh ${CWD}/scripts/stopparity.sh 

sleep 5

sh ${CWD}/scripts/startparity.sh

