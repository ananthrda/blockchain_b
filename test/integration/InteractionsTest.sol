//SPDX-License-Identifier: MIT
import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

pragma solidity ^0.8.19;

contract interactionsTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    address alice = makeAddr("alice");

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(alice, STARTING_USER_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundme = new FundFundMe();
        fundFundme.fundFundme(address(fundMe));

        vm.prank(alice);
        fundMe.fund{value: SEND_VALUE}();
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withDrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
