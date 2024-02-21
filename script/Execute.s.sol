// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script,console} from 'forge-std/Script.sol';
import {AccountFactory} from '../src/AccountFactory.sol';
import {EntryPoint} from '../src/EntryPoint.sol';
import {DeployEP} from './DeployEP.s.sol';
import {UserOperation} from '@account-abstraction/contracts/interfaces/UserOperation.sol';
import {SmartAccount} from '../src/SmartAccount.sol';
import {ECDSA} from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
import {Deposit} from './Deposit.s.sol';
contract Execute is Script {

    using ECDSA for bytes32;

    EntryPoint ep;
    AccountFactory accountFactory;    

    function run() public {
        
        DeployEP epDeployer = new DeployEP();

        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        uint256 privateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        
        (ep,accountFactory) = epDeployer.run();


        bytes memory initCode = abi.encode(0x0);
        initCode = abi.encodePacked(address(accountFactory),abi.encodeWithSignature("createAccount(address)",owner));

        address sender = address(0x0);
        try ep.getSenderAddress(initCode) {

        } 
        catch (bytes memory lowLevelData) {
            sender = extractGetSenderAddr(lowLevelData);
            console.log(sender);
        }
        
        
        Deposit deposit = new Deposit();
        deposit.deposit{value: 0.3 ether}(ep,sender);


        // Check and see if account has been deployed. if not, create initCode
        if (accountFactory.accounts_created(owner) == true) {
            initCode = "";
        } 
        console.logBytes(initCode);

        // Create UserOperation for transaction
        UserOperation memory userOp = UserOperation({
            sender: sender,
            nonce: ep.getNonce(sender,0),
            initCode: initCode,
            callData: abi.encodeWithSignature("execute()"),
            callGasLimit: 1_500_000,
            verificationGasLimit: 1500000,
            preVerificationGas: 150000,
            maxFeePerGas: 150000,
            maxPriorityFeePerGas: 150000,
            paymasterAndData: "",
            signature: ""
        });

        bytes32 userOpHash = ep.getUserOpHash(userOp);
        userOp.signature = getSignature(privateKey,userOpHash);

        UserOperation[] memory userOps = new UserOperation[](1);
        userOps[0] = userOp;
        
        vm.startBroadcast();
        ep.handleOps(userOps,payable(owner));
        vm.stopBroadcast();
        
        // uint count = SmartAccount(sender).count();
        // console.log(count);

    }

    function getSignature(uint256 privateKey,bytes32  ophash) public pure returns(bytes memory) {
        bytes32 digest = keccak256(abi.encodePacked(ophash)).toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey,digest);
        bytes memory signature = abi.encodePacked(r,s,v);
 
        return signature;

    }

    function extractGetSenderAddr(bytes memory lowLevelData) public pure returns(address) {
            uint len = lowLevelData.length;
            uint start = len-20;
            bytes memory addr = new bytes(20);
            uint pos = 0;
            for (uint i = start; i < len; i++) {
                addr[pos] = lowLevelData[i];
                pos++;
            }
            return address(bytes20(addr));
    }
}