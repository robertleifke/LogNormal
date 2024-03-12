// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import { FixedPointMathLib } from "solmate/utils/FixedPointMathLib.sol";
import { TWO, HALF } from "src/lib/StrategyLib.sol";

using FixedPointMathLib for uint256;
using FixedPointMathLib for int256;

function computeLnSDivK(uint256 S, uint256 K) pure returns (int256 lnSDivK) {
    lnSDivK = int256(S.divWadUp(K)).lnWad();
}

/**
 * @dev Computes the half of the square of sigma.
 *
 * $$\frac{1}{2}\sigma^2$$
 *
 */
function computeHalfSigmaSquared(uint256 sigma) pure returns (uint256) {
    return HALF.mulWadDown(uint256(int256(sigma).powWad(int256(TWO))));
}

function computeDeltaGivenDeltaLRoundUp(
    uint256 reserve,
    uint256 deltaLiquidity,
    uint256 totalLiquidity
) pure returns (uint256) {
    return reserve.mulWadUp(deltaLiquidity.divWadUp(totalLiquidity));
}

function computeDeltaGivenDeltaLRoundDown(
    uint256 reserve,
    uint256 deltaLiquidity,
    uint256 totalLiquidity
) pure returns (uint256) {
    return reserve.mulWadDown(deltaLiquidity.divWadDown(totalLiquidity));
}
