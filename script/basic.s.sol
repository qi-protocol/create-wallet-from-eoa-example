pragma solidity ^0.8.15;

import "forge-std/Vm.sol";
import "forge-std/Script.sol";
import {SimpleAccount, SimpleAccountFactory, UserOperation, IEntryPoint} from "@erc4337/samples/SimpleAccountFactory.sol";
import "account-abstraction/interfaces/IEntryPoint.sol";

contract SimpleAccountSetup is Script {
    address internal eoaAddress;

    // Entry point
    address internal entryPointAddress = 0x0576a174D229E3cFA37253523E645A78A0C91B57;
    IEntryPoint public entryPoint = IEntryPoint(entryPoint);

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
    }

    function run() public {
        vm.startBroadcast(privateKey);
        
        simpleAccountFactory = new SimpleAccountFactory(entryPoint);
        simpleAccountFactoryAddress = address(simpleAccountFactory);
        simpleAccount = simpleAccountFactory.createAccount(eoaAddress, SALT);
        simpleAccountAddress = address(simpleAccount);

        console.log("All Live EVM:");
        console.log("EOA: ", eoaAddress);
        console.log("EntryPoint: ", entryPointAddress);
        console.log("Simple Factory: ", simpleAccountFactoryAddress);
        console.log("SALT: ", SALT);
        console.log("Simple Account: ", simpleAccountAddress);

        vm.stopBroadcast();
    }
}