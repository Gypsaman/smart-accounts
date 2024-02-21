// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script,console} from 'forge-std/Script.sol';
import {EntryPoint} from '../src/EntryPoint.sol';


contract Deposit is Script {

    function deposit(EntryPoint ep, address sender) public payable {
        vm.broadcast();
        ep.depositTo{value: msg.value}(sender);
        
    }
}