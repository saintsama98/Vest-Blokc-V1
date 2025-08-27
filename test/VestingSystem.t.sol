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
import "../src/factory/VestingWalletManager.sol";
import "../src/VestingWallet.sol";
import "./MockERC20Votes.sol";

contract VestingSystemTest is Test {
    VestingWalletManager manager;
    address user = address(0x1);
    address beneficiary = address(0x2);
    uint64 start = uint64(block.timestamp + 1 days);
    uint64 duration = 30 days;
    uint64 cliff = 7 days;

    function setUp() public {
        manager = new VestingWalletManager();
    }

    /// @notice Tests the creation of a vesting wallet and its registration

    function testFactoryCreatesVestingWalletAndRegisters() public {
        vm.prank(user);
        address walletAddr = manager.createVestingWallet(beneficiary, start, duration, cliff);
        address[] memory userWallets = manager.getUserVestings(user);
        assertEq(userWallets.length, 1);
        assertEq(userWallets[0], walletAddr);
    }

    /// @notice Tests the delegation and revocation of tokens in a vesting wallet

    function testVestingWalletDelegateAndRevoke() public {
        vm.prank(user);
        address walletAddr = manager.createVestingWallet(beneficiary, start, duration, cliff);
        VestingWalletBlokc wallet = VestingWalletBlokc(payable(walletAddr));
        MockERC20Votes token = new MockERC20Votes();
        // Mint tokens to vesting wallet
        token.mint(address(wallet), 1000 ether);
        // Test delegate
        vm.prank(beneficiary);
        wallet.delegate(address(token), beneficiary);
        assertEq(token.delegates(address(wallet)), beneficiary);
        // Test revoke
        vm.prank(beneficiary);
        wallet.revoke(address(token), beneficiary);
        // After revoke, unvested tokens should be transferred to beneficiary
        assertEq(token.balanceOf(beneficiary), 1000 ether);
    }

    /// @notice Tests the retrieval of vesting wallets for a specific user

    function testRegistryGlobalList() public {
        vm.prank(user);
        address walletAddr = manager.createVestingWallet(beneficiary, start, duration, cliff);
        address[] memory allWallets = manager.getAllVestings();
        assertEq(allWallets.length, 1);
        assertEq(allWallets[0], walletAddr);
    }
}
