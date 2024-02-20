// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from 'forge-std/Test.sol';
import {Vm} from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";
contract testVM is Test {

   function setUp() public {
   }

   function testReadDir() view public {
        console.log("Test Read Dir");
        Vm.DirEntry[] memory files = vm.readDir("./broadcast",3);
        for (uint i = 0; i < files.length; i++) {
             console.log(files[i].path);
        }
        assert(files.length > 0);
   } 
}