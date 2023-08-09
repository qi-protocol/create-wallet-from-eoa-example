// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "forge-std/StdCheats.sol";
//import "forge-std/console.sol";

import {EntryPoint} from "@erc4337/core/EntryPoint.sol";
import {SimpleAccount, SimpleAccountFactory, UserOperation} from "@erc4337/samples/SimpleAccountFactory.sol";

contract basicTest {
    // Entry point
    EntryPoint public entryPoint;
    address internal entryPointAddress;

    // Factory for individual 4337 accounts
    SimpleAccountFactory public simpleAccountFactory;

    SimpleAccount public simpleAccount;
    address internal simpleAccountAddress;

    bytes32 internal constant SALT = "0x55";
    
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
        uint256 privateKey = vm.addr(vm.parseBytes32(key));
        address eoaAddress = address(vm.publicKey());
        //vm.logBytes32(eoaAddress);
        entryPoint = new EntryPoint();
        entryPointAddress = address(entryPoint);
        simpleAccountFactory = new SimpleAccountFactory(entryPointAddress);
        simpleAccountFactory.createAccount(eoaAddress, SALT);
    }
}