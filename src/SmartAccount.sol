// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@account-abstraction/contracts/interfaces/IAccount.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import {console} from 'forge-std/Script.sol';

contract SmartAccount is IAccount {
    uint public count;
    address owner;

    constructor(address _owner) {
        owner = _owner;
    }
    function validateUserOp(UserOperation calldata userOp, bytes32 userOpHash , uint256 )
    external view returns(uint256 validationData)
    {
        
        address recovered = ECDSA.recover(
            ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(userOpHash))), 
            userOp.signature
            );
        return recovered == owner ? 0 : 1;
    }

    function execute() external {
        count++;
    }
}

contract TestAccount {
    address public recovered;
    constructor(bytes memory sig) {
        recovered = ECDSA.recover(ECDSA.toEthSignedMessageHash(keccak256("test")), sig);
        
    }
}

