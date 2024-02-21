// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script,console} from 'forge-std/Script.sol';
import {EntryPoint} from '../src/EntryPoint.sol';
import {AccountFactory} from '../src/AccountFactory.sol';
import {DevOpsTools} from 'foundry-devops/src/DevOpsTools.sol';
import {Create2} from '@openzeppelin/contracts/utils/Create2.sol';


contract DeployEPTest is Script {

    EntryPoint ep;
    AccountFactory accountFactory;

    function run() public {
        //  bytes memory bytecode = abi.encodePacked(type(AccountFactory).creationCode);
        // bytes32 salt = bytes32(uint256(uint160(block.chainid)));

        // address calcAddr = Create2.computeAddress(salt,keccak256(bytecode),address(0x4e59b44847b379578588920cA78FbF26c0B4956C));

        
        // console.log('calcAddr: ', calcAddr);
        vm.startBroadcast();
        accountFactory = new AccountFactory();
        // accountFactory = new AccountFactory{salt:salt}();
        console.log('accountFactory: ', address(accountFactory));
        // vm.stopBroadcast();
        // assert(address(accountFactory) == calcAddr);
  
        address accountAddr = accountFactory.createAccount(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));
        vm.stopBroadcast();
        console.log('accountAddr: ', accountAddr);
    }

}