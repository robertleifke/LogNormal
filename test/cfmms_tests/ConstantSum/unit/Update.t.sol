// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { LogNormalSetUp, LogNormalParams } from "./SetUp.sol";
import {
    encodeFeeUpdate,
    encodeMeanUpdate,
    encodeWidthUpdate,
    encodeControllerUpdate
} from "src/LogNormal/LogNormalUtils.sol";

contract LogNormalUpdateTest is LogNormalSetUp {
    // function test_LogNormal_update_SetsSwapFee() public defaultPool {
    //     skip();
    //     uint256 newFee = 0.004 ether;
    //     dfmm.update(POOL_ID, encodeFeeUpdate(newFee));
    //     LogNormalParams memory poolParams =
    //         abi.decode(logNormal.getPoolParams(POOL_ID), (LogNormalParams));
    //     assertEq(poolParams.swapFee, newFee);
    // }

    // function test_LogNormal_update_SetsMean() public defaultPool {
    //     skip();
    //     uint256 newPrice = 3 ether;
    //     dfmm.update(POOL_ID, encodeMeanUpdate(newMean));
    //     LogNormalParams memory poolParams =
    //         abi.decode(logNormal.getPoolParams(POOL_ID), (LogNormalParams));
    //     assertEq(poolParams.mean, newMean);
    // }

    // function test_LogNormal_update_SetsWidth() public defaultPool {
    //     skip();
    //     uint256 newWidth = 3 ether;
    //     dfmm.update(POOL_ID, encodeWidthUpdate(newWidth));
    //     LogNormalParams memory poolParams =
    //         abi.decode(logNormal.getPoolParams(POOL_ID), (LogNormalParams));
    //     assertEq(poolParams.width, newWidth);
    // }

    // function test_LogNormal_update_SetsController() public defaultPool {
    //     skip();
    //     address newController = address(this);
    //     dfmm.update(POOL_ID, encodeControllerUpdate(newController));
    //     LogNormalParams memory poolParams =
    //         abi.decode(logNormal.getPoolParams(POOL_ID), (LogNormalParams));
    //     assertEq(poolParams.controller, newController);
    // }
}
