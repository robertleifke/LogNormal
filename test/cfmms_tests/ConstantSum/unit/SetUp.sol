// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "src/LogNormal/LogNormal.sol";
import "src/LogNormal/LogNormalSolver.sol";
import "test/utils/SetUp.sol";
import { InitParams } from "src/interfaces/IDFMM.sol";

contract LogNormalSetUp is SetUp {
    // LogNormal logNormal;
    // LogNormalSolver solver;

    // uint256 public POOL_ID;

    // LogNormalParams defaultParams = LogNormalParams({
    //     mean: 2 ether,
    //     width: 1 ether,
    //     swapFee: TEST_SWAP_FEE,
    //     controller: address(0)
    // });

    // LogNormalParams zeroFeeParams = LogNormalParams({
    //     mean: 2 ether,
    //     width: 1 ether,
    //     swapFee: 0,
    //     controller: address(0)
    // });

    // function setUp() public override {
    //     SetUp.setUp();
    //     logNormal = new LogNormal(address(dfmm));
    //     solver = new LogNormalSolver(address(logNormal));
    // }

    // modifier defaultPool() {
    //     uint256 reserveX = 1 ether;
    //     uint256 reserveY = 1 ether;

    //     bytes memory initData =
    //         solver.getInitialPoolData(reserveX, reserveY, defaultParams);

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

    //     _;
    // }

    // modifier zeroFeePool() {
    //     uint256 reserveX = 1 ether;
    //     uint256 reserveY = 1 ether;

    //     bytes memory initData =
    //         solver.getInitialPoolData(reserveX, reserveY, zeroFeeParams);

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

    //     _;
    // }
}
