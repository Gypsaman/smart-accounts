// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script,console} from 'forge-std/Script.sol';
import {EntryPoint} from '../src/EntryPoint.sol';
import {AccountFactory} from '../src/AccountFactory.sol';
import {DevOpsTools} from 'foundry-devops/src/DevOpsTools.sol';
import {Create2} from '@openzeppelin/contracts/utils/Create2.sol';

contract DeployEP is Script {

    AccountFactory accountFactory;
    EntryPoint ep;

    function run() public returns(EntryPoint, AccountFactory) {

        vm.startBroadcast();
        
        accountFactory = new AccountFactory();
        console.log("AccountFactory deployed at: ", address(accountFactory));

        ep = new EntryPoint();
        console.log("EntryPoint deployed at: ", address(ep));
        
        vm.stopBroadcast();
        return (ep, accountFactory);

    }

    function getDeployed() public returns(EntryPoint, AccountFactory) {
        ep = EntryPoint(payable(address(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512)));
        accountFactory = AccountFactory(address(0x5FbDB2315678afecb367f032d93F642f64180aa3));
        

        return (ep, accountFactory);
    }



}

contract DeployEPTest is Script {
    DeployEP deployEP;
    EntryPoint ep;
    AccountFactory accountFactory;

    function setUp() public {
         bytes memory bytecode = abi.encodePacked(type(AccountFactory).creationCode);
        bytes32 salt = bytes32(uint256(uint160(block.chainid)));

        address calcAddr = Create2.computeAddress(salt,keccak256(bytecode),msg.sender);

        
        console.log('calcAddr: ', calcAddr);
        vm.startBroadcast();
        address accountFactoryAddr = Create2.deploy(0,salt,bytecode);
        console.log('accountFactoryAddr: ', accountFactoryAddr);
        vm.stopBroadcast();
        assert(accountFactoryAddr == calcAddr);
        
    }

}