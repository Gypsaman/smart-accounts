// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test,console} from 'forge-std/Test.sol';
import {ECDSA} from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
import {TestAccount} from '../src/SmartAccount.sol';

contract TestECDSA is Test {
    using ECDSA for bytes32;
    address signer;
    uint256 internal privateKey;
    bytes signature;
    function setUp() public {

        privateKey = 0x5d3e7e3f;
        signer = vm.addr(privateKey);

        bytes32 digest = keccak256(abi.encodePacked('test')).toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey,digest);
        signature = abi.encodePacked(r,s,v);

    }
    function testSignature() public {
        vm.prank(signer);
        TestAccount test = new TestAccount(signature);
        address recovered = test.recovered();
        
        assert(recovered==signer);

    }
}