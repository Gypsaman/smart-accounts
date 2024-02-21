// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script,console} from 'forge-std/Script.sol';
import {EntryPoint} from '../src/EntryPoint.sol';
import {AccountFactory} from '../src/AccountFactory.sol';
import {Create2} from '@openzeppelin/contracts/utils/Create2.sol';

contract DeployEP is Script {

    AccountFactory accountFactory;
    EntryPoint ep;

    function run() public returns(EntryPoint, AccountFactory) {
        
        bytes memory bytecode = abi.encodePacked(type(AccountFactory).creationCode);
        bytes32 salt = bytes32(uint256(uint160(block.chainid)));

        address calcAddr = Create2.computeAddress(salt,keccak256(bytecode),address(0x4e59b44847b379578588920cA78FbF26c0B4956C));
        if (calcAddr.code.length > 0) {
            accountFactory = AccountFactory(calcAddr);
        } else {
            console.log('Deploying new AccountFactory');
            vm.broadcast();
            accountFactory = new AccountFactory{salt:salt}();
        }

        bytecode = abi.encodePacked(type(EntryPoint).creationCode);
        calcAddr = Create2.computeAddress(salt,keccak256(bytecode),address(0x4e59b44847b379578588920cA78FbF26c0B4956C));
        if (calcAddr.code.length > 0) {
            ep = EntryPoint(payable(calcAddr));
        } else {
            console.log('Deploying new EntryPoint');
            vm.broadcast();
            ep = new EntryPoint{salt:salt}();
        }

        console.log("AccountFactory deployed at: ", address(accountFactory));
        console.log("EntryPoint deployed at: ", address(ep));

        return (ep, accountFactory);
    }
}

