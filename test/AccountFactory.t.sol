// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from 'forge-std/Test.sol';
import {AccountFactory} from '../src/AccountFactory.sol';
import {SmartAccount} from '../src/SmartAccount.sol';
import "@openzeppelin/contracts/utils/Create2.sol";

contract AccountFactoryTest is Test {
    AccountFactory accountFactory;
    SmartAccount account;

    function setUp() public {
        accountFactory = new AccountFactory();
    }
    function testCreateAccount() public {
        address owner = address(this);
        address accountAddress = accountFactory.createAccount(owner);

        
        assert(accountAddress != address(0));
    }
    function testExecute() public {
        address owner = address(this);
        
        account = new SmartAccount(owner);
        uint count = account.count();
        account.execute();
        assert(account.count() == (count + 1));
    }

    function testCreate2() public {

        bytes memory bytecode = abi.encodePacked(type(AccountFactory).creationCode);
        bytes32 salt = bytes32(uint256(uint160(block.chainid)));

        address calcAddr = Create2.computeAddress(salt,keccak256(bytecode));

        
        console.log('calcAddr: ', calcAddr);
        vm.startBroadcast();
        address accountFactoryAddr = Create2.deploy(0,salt,bytecode);
        console.log('accountFactoryAddr: ', accountFactoryAddr);
        vm.stopBroadcast();
        assert(accountFactoryAddr == calcAddr);
        

    }
}