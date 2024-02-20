// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from 'forge-std/Test.sol';
import {console} from "forge-std/console.sol";
import {EntryPoint} from '../src/EntryPoint.sol';
import {AccountFactory} from '../src/AccountFactory.sol';
import {DeployEP} from '../script/DeployEP.s.sol';
contract testVM is Test {

    EntryPoint ep;
    AccountFactory accountFactory;

    function setUp() public {
    }   

    function testDeployEP() public {
        console.log("Test Deploy EP");
        DeployEP deployEP = new DeployEP();
        (ep, accountFactory) = deployEP.run();
        assertTrue(address(ep) != address(0), "EntryPoint not deployed");
        assertTrue(address(accountFactory) != address(0), "AccountFactory not deployed");
    }


}