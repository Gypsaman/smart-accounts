// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script,console} from 'forge-std/Script.sol';
import {EntryPoint} from '../src/EntryPoint.sol';
import {AccountFactory} from '../src/AccountFactory.sol';
import {SmartAccount} from '../src/SmartAccount.sol';

contract testAF is Script {

    function run() public {
        
        address factory = address(0x79B55585dAEd081eb5aF42871765697F7c78C5cB);
        AccountFactory af = AccountFactory(factory);
        address owner = address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        vm.startBroadcast();
        address account = af.createAccount(owner);
        // address account = address(0x1E4520cF040E8ADE13b735FD00497cB49C322aDE);
        SmartAccount sa = SmartAccount(account);
        console.log(address(sa));
        console.log(account.code.length);
        
        sa.execute();
        vm.stopBroadcast();
        console.log(sa.count());
    }
}