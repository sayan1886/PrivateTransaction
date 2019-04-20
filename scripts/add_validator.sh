#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

## Configure chain specification like validator and add balances

SIGNER_NODE1=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node1", "node1"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8545 | jq '.result')
SIGNER_NODE1=$(echo ${SIGNER_NODE1} | tr -d '"')
SIGNER_NODE2=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node2", "node2"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8547 | jq '.result')
SIGNER_NODE2=$(echo ${SIGNER_NODE2} | tr -d '"')
SIGNER_NODE3=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node3", "node3"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8549 | jq '.result')
SIGNER_NODE3=$(echo ${SIGNER_NODE3} | tr -d '"')
SIGNER_NODE4=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node4", "node4"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8551 | jq '.result')
SIGNER_NODE4=$(echo ${SIGNER_NODE4} | tr -d '"')

MAIN_CHAIN_NAME="${PARITY_HOME}/chain.json"
TMP_CHAIN_1_NAME="${TMP_DIR}/chain1.json"
TMP_CHAIN_2_NAME="${TMP_DIR}/chain2.json"
TMP_CHAIN_3_NAME="${TMP_DIR}/chain3.json"

RELAY_SET_ADDR="0x0000000000000000000000000000001000000000"
jq '.engine.authorityRound.params.validators.safeContract += "'${RELAY_SET_ADDR}'"' $MAIN_CHAIN_NAME > $TMP_CHAIN_1_NAME

VALIDATOR_CONTRACT="${CWD}/contracts/RelayedOwnedSet.sol"
SOLC_OUT=${TMP_DIR}"/solcoutput/"
VALIDATOR_CONTRACT_BIN="${SOLC_OUT}RelayedOwnedSet.bin"
RELAY_SET_ADDR=${RELAY_SET_ADDR:2}
OWNER_ADDR=${SIGNER_NODE1:2}
VALIDATOR_ADDR=[${SIGNER_NODE1:2},${SIGNER_NODE2:2},${SIGNER_NODE3:2},${SIGNER_NODE4:2}]

mkdir -p ${SOLC_OUT}

solc --bin --overwrite --gas -o ${SOLC_OUT} ${VALIDATOR_CONTRACT}

VALIDATOR_CONTRACT_BIN=$(cat ${VALIDATOR_CONTRACT_BIN})


VALIDATOR_CONTRACT_PARAMS=$(ethabi encode params -v  address ${RELAY_SET_ADDR} -v address ${OWNER_ADDR} -v address[] ${VALIDATOR_ADDR}  -l)

# VALIDATOR_CONTRACT_PARAMS=$(ethabi encode params -v  address ${RELAY_SET_ADDR} -v address[] ${VALIDATOR_ADDR}  -l)


VALIDATOR_CONTRACT_BIN=${VALIDATOR_CONTRACT_BIN}${VALIDATOR_CONTRACT_PARAMS}

jq '.accounts += {"'${RELAY_SET_ADDR}'":{"balance":"1","constructor":"'${VALIDATOR_CONTRACT_BIN}'"}}' ${TMP_CHAIN_1_NAME} > ${TMP_CHAIN_2_NAME}

jq '.accounts += {"'${SIGNER_NODE1}'":{"balance":"10000000000000000000000"}}' ${TMP_CHAIN_2_NAME} > ${TMP_CHAIN_1_NAME}
jq '.accounts += {"'${SIGNER_NODE2}'":{"balance":"10000000000000000000000"}}'  ${TMP_CHAIN_1_NAME} > ${TMP_CHAIN_2_NAME}
jq '.accounts += {"'${SIGNER_NODE3}'":{"balance":"10000000000000000000000"}}'  ${TMP_CHAIN_2_NAME} > ${TMP_CHAIN_1_NAME}
jq '.accounts += {"'${SIGNER_NODE4}'":{"balance":"10000000000000000000000"}}'  ${TMP_CHAIN_1_NAME} > ${TMP_CHAIN_2_NAME}

mv ${TMP_CHAIN_2_NAME} ${MAIN_CHAIN_NAME}

OWNER_ADDRESS="0x${OWNER_ADDR}"
VALIDATOR_CONTRACT_BIN="0x${VALIDATOR_CONTRACT_BIN}"

GAS=$(curl -X POST localhost:8545 --data '{"method":"eth_estimateGas","params":[{"from": "'${OWNER_ADDRESS}'", "data":"'${VALIDATOR_CONTRACT_BIN}'"}],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json"  | jq '.result' | tr -d '"')   
GAS=$(($((${GAS}))+50000))
GAS=0x$(echo "obase=16; ${GAS}" | bc)
# TRANSACTION_HASH=$(curl -X POST localhost:8545 --data '{"method":"eth_sendTransaction","params":[{"from": "'${OWNER_ADDRESS}'", "gas":"'${GAS}'", "data":"'${VALIDATOR_CONTRACT_BIN}'"}],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" | jq '.result' &)
# CONTRACT_ADDRESS=$(curl localhost:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":['${TRANSACTION_HASH}'],"id":1}' | jq '.result.contractAddress' &)

# echo "**************************${CONTRACT_ADDRESS}************************"
