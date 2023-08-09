pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import {SimpleAccount, SimpleAccountFactory, UserOperation, IEntryPoint} from "@erc4337/samples/SimpleAccountFactory.sol";
import "account-abstraction/interfaces/IEntryPoint.sol";

contract SimpleAccountSetup is Script {
    address entryPointAddress = 0x0576a174D229E3cFA37253523E645A78A0C91B57;
    IEntryPoint public entryPoint = IEntryPoint(entryPoint);

    // Factory for individual 4337 accounts
    SimpleAccountFactory public simpleAccountFactory;

    SimpleAccount public simpleAccount;
    address internal simpleAccountAddress;

    bytes32 internal constant SALT = "0x55";

    function setUp() public {}

    function run() public {
        string memory key = vm.readFile(".secret");
        uint256 privateKey = vm.addr(vm.parseBytes32(key));
        address eoaAddress = address(vm.publicKey());

        // deploy and initialized, base account and factory
        simpleAccountFactory = new SimpleAccountFactory(IEntryPoint(entryPoint));
        simpleAccountAddress = simpleAccountFactory.createAccount(eoaAddress, SALT);

        
        // deploy wallet account


        // deposit funds

        vm.stopBroadcast();
    }
}