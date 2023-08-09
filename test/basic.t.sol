// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

import {Vm as vm} from "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "forge-std/StdCheats.sol";
import "forge-std/console.sol";

import {EntryPoint, IEntryPoint} from "@erc4337/core/EntryPoint.sol";
import {SimpleAccount, SimpleAccountFactory, UserOperation} from "@erc4337/samples/SimpleAccountFactory.sol";

contract basicTest is Test {
    address internal eoaAddress;

    // Entry point
    EntryPoint public entryPoint;
    address internal entryPointAddress;

    // Factory for individual 4337 accounts
    SimpleAccountFactory public simpleAccountFactory;
    address internal simpleAccountFactoryAddress;

    SimpleAccount public simpleAccount;
    address internal simpleAccountAddress;

    uint256 internal constant SALT = 0x55;
    
    uint256[2] internal publicKey;
    string internal constant SIGNER_1 = "1";

    UserOperation public userOpBase = UserOperation({
        sender: address(0),
        nonce: 0,
        initCode: new bytes(0),
        callData: new bytes(0),
        callGasLimit: 10000000,
        verificationGasLimit: 20000000,
        preVerificationGas: 20000000,
        maxFeePerGas: 2,
        maxPriorityFeePerGas: 1,
        paymasterAndData: new bytes(0),
        signature: new bytes(0)
    });

    function setUp() public {
        string memory key = vm.readFile(".secret");
        bytes32 key_bytes = vm.parseBytes32(key);
        uint256 privateKey;
        assembly {
            privateKey := key_bytes
        }
        eoaAddress = vm.addr(privateKey);
        entryPoint = new EntryPoint();
        entryPointAddress = address(entryPoint);
        simpleAccountFactory = new SimpleAccountFactory(IEntryPoint(entryPointAddress));
        simpleAccountFactoryAddress = address(simpleAccountFactory);
        simpleAccount = simpleAccountFactory.createAccount(eoaAddress, SALT);
        simpleAccountAddress = address(simpleAccount);
    }

    function testCreate() public {
        console.log("All local EVM:");
        console.log("EOA: ", eoaAddress);
        console.log("EntryPoint: ", entryPointAddress);
        console.log("Simple Factory: ", simpleAccountFactoryAddress);
        console.log("SALT: ", SALT);
        console.log("Simple Account: ", simpleAccountAddress);
    }
}