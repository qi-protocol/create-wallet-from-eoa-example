// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

import {Vm as vm} from "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "forge-std/StdCheats.sol";
import "forge-std/console.sol";

import {EntryPoint, IEntryPoint} from "@erc4337/core/EntryPoint.sol";
import {SimpleAccount, SimpleAccountFactory, UserOperation} from "@erc4337/samples/SimpleAccountFactory.sol";
import {ECDSA} from "lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract fromEntryPointTest is Test {
    using ECDSA for bytes32;
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
        uint256 gas = gasleft();
       // simpleAccount = simpleAccountFactory.createAccount(eoaAddress, SALT);

        bytes memory initCode_ = abi.encodePacked(simpleAccountFactory, abi.encodeWithSignature("createAccount(address,uint256)", eoaAddress, SALT));
        UserOperation memory userOp = userOpBase;
        address sender_ = simpleAccountFactory.getAddress(eoaAddress, SALT);
        userOp.sender = sender_;
        userOp.initCode = initCode_;
        bytes32 userOpHash = entryPoint.getUserOpHash(userOp);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, userOpHash.toEthSignedMessageHash());
        userOp.signature = abi.encodePacked(r, s, v);
        entryPoint.depositTo{value: 1 ether}(sender_);
        UserOperation[] memory userOps = new UserOperation[](1);
        userOps[0] = (userOp);
        bytes memory payload_ = abi.encodeWithSelector(bytes4(0x1fad948c), userOps, payable(address(uint160(uint256(6666)))));
        gas = gasleft();
        assembly {
            pop(call(gas(), sload(entryPointAddress.slot), 0, add(payload_, 0x20), mload(payload_), 0, 0))
        }
        //entryPoint.handleOps(userOps, payable(address(uint160(uint256(6666)))));
        console.log("gas used for factory deployment", gas - gasleft());
        uint256 newSize;
        address newAddress = sender_;
            assembly {
                newSize := extcodesize(newAddress)
            }
        console.log("new address", newAddress);
        console.log("new balance", entryPoint.balanceOf(sender_));
        console.log("new address size", newSize);
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