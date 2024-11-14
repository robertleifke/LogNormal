// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { LogNormalParams } from "src/LogNormal/LogNormal.sol";
import { LogNormalSetUp, InitParams } from "./SetUp.sol";

contract LogNormalGetPoolParamsTest is LogNormalSetUp {
    // function test_LogNormal_getPoolParams_ReturnsPoolParams() public {
    //     LogNormalParams memory initPoolParams = LogNormalParams({
    //         price: 2 ether,
    //         swapFee: TEST_SWAP_FEE,
    //         controller: address(this)
    //     });

    //     uint256 reserveX = 1 ether;
    //     uint256 reserveY = 1 ether;

    //     bytes memory initData =
    //         solver.getInitialPoolData(reserveX, reserveY, initPoolParams);

    //     address[] memory tokens = new address[](2);
    //     tokens[0] = address(tokenX);
    //     tokens[1] = address(tokenY);

    //     InitParams memory initParams = InitParams({
    //         name: "",
    //         symbol: "",
    //         strategy: address(logNormal),
    //         tokens: tokens,
    //         data: initData,
    //         feeCollector: address(0),
    //         controllerFee: 0
    //     });

    //     (POOL_ID,,) = dfmm.init(initParams);

    //     LogNormalParams memory poolParams =
    //         abi.decode(logNormal.getPoolParams(POOL_ID), (LogNormalParams));
    //     assertEq(poolParams.swapFee, initPoolParams.swapFee);
    //     assertEq(poolParams.price, initPoolParams.price);
    //     assertEq(poolParams.controller, initPoolParams.controller);
    // }
}
