// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*###############################################################################

    @title Vesting Wallet test
    @author BLOK Capital DAO
    @notice This contract implements logic for Vesting Wallet testing

    ▗▄▄▖ ▗▖    ▗▄▖ ▗▖ ▗▖     ▗▄▄▖ ▗▄▖ ▗▄▄▖▗▄▄▄▖▗▄▄▄▖▗▄▖ ▗▖       ▗▄▄▄  ▗▄▖  ▗▄▖ 
    ▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌▗▞▘    ▐▌   ▐▌ ▐▌▐▌ ▐▌ █    █ ▐▌ ▐▌▐▌       ▐▌  █▐▌ ▐▌▐▌ ▐▌
    ▐▛▀▚▖▐▌   ▐▌ ▐▌▐▛▚▖     ▐▌   ▐▛▀▜▌▐▛▀▘  █    █ ▐▛▀▜▌▐▌       ▐▌  █▐▛▀▜▌▐▌ ▐▌
    ▐▙▄▞▘▐▙▄▄▖▝▚▄▞▘▐▌ ▐▌    ▝▚▄▄▖▐▌ ▐▌▐▌  ▗▄█▄▖  █ ▐▌ ▐▌▐▙▄▄▖    ▐▙▄▄▀▐▌ ▐▌▝▚▄▞▘


################################################################################*/

import "forge-std/Test.sol";
import "../src/factory/VestingWalletFactory.sol";
import "../src/VestingWallet.sol";
import "./mocks/MockERC20Votes.sol";

contract VestingSystemTest is Test {
    VestingWalletFactory factory;
    address user = address(0x1);
    address beneficiary = address(0x2);
    uint64 start = uint64(block.timestamp + 1 days);
    uint64 duration = 30 days;
    uint64 cliff = 7 days;

    function setUp() public {
        factory = new VestingWalletFactory();
    }

    /// @notice Tests the creation of a vesting wallet and its registration

    function testFactoryCreatesVestingWalletAndRegisters() public {
        vm.prank(user);
        address walletAddr = factory.createVestingWallet(user, beneficiary, start, duration, cliff);
        address[] memory userWallets = factory.getUserVestings(user);
        assertEq(userWallets.length, 1);
        assertEq(userWallets[0], walletAddr);
    }

    /// @notice Tests the delegation and revocation of tokens in a vesting wallet

    function testVestingWalletDelegateAndRevoke() public {
        vm.prank(user);
        address walletAddr = factory.createVestingWallet(user, beneficiary, start, duration, cliff);
        VestingWalletBlokc wallet = VestingWalletBlokc(payable(walletAddr));
        // Transfer ownership from beneficiary to user (DAO/admin)
        vm.prank(beneficiary);
        wallet.transferOwnership(user);
        // Debug: Ensure owner is user before revoke
        assertEq(wallet.owner(), user);
        MockERC20Votes token = new MockERC20Votes();
        // Mint tokens to vesting wallet
        token.mint(address(wallet), 1000 ether);
        // Test delegate (only beneficiary can call)
        vm.prank(beneficiary);
        wallet.delegate(address(token), beneficiary);
        assertEq(token.delegates(address(wallet)), beneficiary);
        // Test revoke (only owner can call)
        vm.prank(wallet.owner());
        wallet.revoke(address(token));
        // After revoke, unvested tokens should be transferred to owner (DAO)
        assertEq(token.balanceOf(user), 1000 ether);
    }

    /// @notice Tests the retrieval of vesting wallets for a specific user

    function testRegistryGlobalList() public {
        vm.prank(user);
        address walletAddr = factory.createVestingWallet(user, beneficiary, start, duration, cliff);
        address[] memory allWallets = factory.getAllVestings();
        assertEq(allWallets.length, 1);
        assertEq(allWallets[0], walletAddr);
    }
}
