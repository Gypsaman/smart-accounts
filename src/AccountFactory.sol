// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SmartAccount} from "./SmartAccount.sol";
import {console} from 'forge-std/Script.sol';
import "@openzeppelin/contracts/utils/Create2.sol";

contract AccountFactory {
    event AccountCreated(address account);
    mapping(address => bool) public accounts_created;
    mapping(address => address) public accounts_addresses;
    SmartAccount account;
    function createAccount(address owner) external returns(address) {
        console.log(address(this));
        bytes32 salt = bytes32(uint256(uint160(owner)));
        bytes memory bytecode = abi.encodePacked(type(SmartAccount).creationCode,abi.encode(owner));
        address addr = Create2.computeAddress(salt,keccak256(bytecode));
        if (addr.code.length > 0) {
            return addr;
        }

        account =  new SmartAccount{salt:salt}(owner);
        emit AccountCreated(addr);
        accounts_created[owner] = true;
        accounts_addresses[owner] = addr;
        return addr;
        
    }
}