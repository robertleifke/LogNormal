// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { LogNormalSetUp } from "./SetUp.sol";
import {
    computeDeltaGivenDeltaLRoundDown,
    LogNormalParams
} from "src/LogNormal/LogNormalMath.sol";

contract LogNormalAllocateTest is LogNormalSetUp {
    // function test_ConstantSum_allocate_Works() public defaultPool {
    //     uint256 deltaX = 0.1 ether;
    //     uint256 deltaY = 0.1 ether;

    //     // Get current state
    //     LogNormalParams memory params = 
    //         abi.decode(logNormal.getPoolParams(POOL_ID), (LogNormalParams));
    //     uint256 totalLiquidity = logNormal.getTotalLiquidity(POOL_ID);
    //     (uint256 reserveX, uint256 reserveY) = logNormal.getReserves(POOL_ID);

    //     // Calculate deltas based on current reserves
    //     uint256 deltaLiquidityX = computeDeltaGivenDeltaLRoundDown(
    //         reserveX,
    //         deltaX,
    //         totalLiquidity
    //     );
    //     uint256 deltaLiquidityY = computeDeltaGivenDeltaLRoundDown(
    //         reserveY,
    //         deltaY,
    //         totalLiquidity
    //     );
    //     uint256 deltaLiquidity = deltaLiquidityX + deltaLiquidityY;

    //     dfmm.allocate(POOL_ID, abi.encode(deltaLiquidity));
    // }
}
