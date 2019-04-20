pragma solidity ^0.5;

contract SecretStorePermissions {
    mapping (bytes32 => address[]) keyOwners;
    mapping (uint => bytes32) keysIndex;
    uint keysCount;
    
    function addKey(address[] memory users, bytes32 key) public {
        keyOwners[key] = users;
        keysIndex[keysCount] = key;
        keysCount = keysCount + 1;
    }

    function checkPermissions(address user, bytes32 document) public view returns (bool) {
        bool key_found = false;
        address[] memory owners;
        for(uint i = 0; i < keysCount; i++) {
            if (keysIndex[i] == document) {
                key_found = true;
                owners = keyOwners[keysIndex[i]];
            }
        }
        
        if (!key_found) {
            return false;
        }
        
        for (uint j = 0; j < owners.length; j++) {
            if (owners[j] == user) {
                return true;
            }
        }
        
        return false;
    }
}