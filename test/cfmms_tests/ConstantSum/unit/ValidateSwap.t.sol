// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { LogNormalSolver } from "src/LogNormal/LogNormalSolver.sol";
import { LogNormalSetUp } from "./SetUp.sol";

contract LogNormalValidateSwapTest is LogNormalSetUp {
    // function test_LogNormal_simulateSwap_RevertsInvalidSwapX()
    //     public
    //     defaultPool
    // {
    //     bool xIn = true;
    //     uint256 amountIn = 1.1 ether;
    //     vm.expectRevert(LogNormalSolver.NotEnoughLiquidity.selector);
    //     solver.simulateSwap(POOL_ID, xIn, amountIn);
    // }

    // function test_LogNormal_simulateSwap_RevertsInvalidSwapY()
    //     public
    //     defaultPool
    // {
    //     bool xIn = false;
    //     uint256 amountIn = 2.1 ether;
    //     vm.expectRevert(LogNormalSolver.NotEnoughLiquidity.selector);
    //     solver.simulateSwap(POOL_ID, xIn, amountIn);
    // }
}
