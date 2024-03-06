// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import "src/interfaces/IDFMM.sol";
import "src/interfaces/IStrategy.sol";
import "src/lib/DynamicParamLib.sol";
import "./LogNormalLib.sol";

/**
 * @title LogNormal Strategy for DFMM.
 * @author Primitive
 */
contract LogNormal is IStrategy {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;
    using DynamicParamLib for DynamicParam;

    struct InternalParams {
        DynamicParam mean;
        DynamicParam width;
        uint256 swapFee;
        address controller;
    }

    /// @dev Parameterization of the Log Normal curve.
    struct LogNormalParams {
        uint256 mean;
        uint256 width;
        uint256 swapFee;
        address controller;
    }

    /// @inheritdoc IStrategy
    address public dfmm;

    /// @inheritdoc IStrategy
    string public constant name = "LogNormal";

    mapping(uint256 => InternalParams) public internalParams;

    /// @param dfmm_ Address of the DFMM contract.
    constructor(address dfmm_) {
        dfmm = dfmm_;
    }

    modifier onlyDFMM() {
        if (msg.sender != dfmm) revert NotDFMM();
        _;
    }

    /// @inheritdoc IStrategy
    function init(
        address,
        uint256 poolId,
        IDFMM.Pool calldata,
        bytes calldata data
    )
        public
        onlyDFMM
        returns (
            bool valid,
            int256 invariant,
            uint256 reserveX,
            uint256 reserveY,
            uint256 totalLiquidity
        )
    {
        (valid, invariant, reserveX, reserveY, totalLiquidity,) =
            _decodeInit(poolId, data);
    }

    /// @dev Decodes, stores and validates pool initialization parameters.
    /// Note that this function was purely made to avoid the stack too deep
    /// error in the `init()` function.
    function _decodeInit(
        uint256 poolId,
        bytes calldata data
    )
        private
        returns (
            bool valid,
            int256 invariant,
            uint256 reserveX,
            uint256 reserveY,
            uint256 totalLiquidity,
            LogNormalParams memory params
        )
    {
        (reserveX, reserveY, totalLiquidity, params) =
            abi.decode(data, (uint256, uint256, uint256, LogNormalParams));

        internalParams[poolId].mean.lastComputedValue = params.mean;
        internalParams[poolId].mean.lastComputedValue = params.width;
        internalParams[poolId].swapFee = params.swapFee;
        internalParams[poolId].controller = params.controller;

        invariant = LogNormalLib.tradingFunction(
            reserveX,
            reserveY,
            totalLiquidity,
            abi.decode(getPoolParams(poolId), (LogNormalParams))
        );
        // todo: should the be EXACTLY 0? just positive? within an epsilon?
        valid = -(EPSILON) < invariant && invariant < EPSILON;
    }

    error DeltaError(uint256 expected, uint256 actual);

    /// @inheritdoc IStrategy
    function validateAllocate(
        address,
        uint256 poolId,
        IDFMM.Pool calldata pool,
        bytes calldata data
    )
        public
        view
        returns (
            bool valid,
            int256 invariant,
            uint256 deltaX,
            uint256 deltaY,
            uint256 deltaLiquidity
        )
    {
        (uint256 maxDeltaX, uint256 maxDeltaY, uint256 deltaL) =
            abi.decode(data, (uint256, uint256, uint256));

        deltaLiquidity = deltaL;
        deltaX = computeDeltaXGivenDeltaL(
            deltaLiquidity, pool.totalLiquidity, pool.reserveX
        );
        deltaY = computeDeltaYGivenDeltaX(deltaX, pool.reserveX, pool.reserveY);

        if (deltaX > maxDeltaX) revert DeltaError(maxDeltaX, deltaX);
        if (deltaY > maxDeltaY) revert DeltaError(maxDeltaY, deltaY);

        uint256 poolId = poolId;

        invariant = LogNormalLib.tradingFunction(
            pool.reserveX + deltaX,
            pool.reserveY + deltaY,
            pool.totalLiquidity + deltaLiquidity,
            abi.decode(getPoolParams(poolId), (LogNormalParams))
        );

        valid = -(EPSILON) < invariant && invariant < EPSILON;
    }

    /// @inheritdoc IStrategy
    function validateDeallocate(
        address,
        uint256 poolId,
        IDFMM.Pool calldata pool,
        bytes calldata data
    )
        public
        view
        returns (
            bool valid,
            int256 invariant,
            uint256 deltaX,
            uint256 deltaY,
            uint256 deltaLiquidity
        )
    {
        (uint256 minDeltaX, uint256 minDeltaY, uint256 deltaL) =
            abi.decode(data, (uint256, uint256, uint256));

        deltaLiquidity = deltaL;
        deltaX = computeDeltaXGivenDeltaL(
            deltaLiquidity, pool.totalLiquidity, pool.reserveX
        );
        deltaY = computeDeltaYGivenDeltaX(deltaX, pool.reserveX, pool.reserveY);

        if (minDeltaX > deltaX) revert DeltaError(minDeltaX, deltaX);
        if (minDeltaY > deltaY) revert DeltaError(minDeltaY, deltaY);

        uint256 poolId = poolId;

        invariant = LogNormalLib.tradingFunction(
            pool.reserveX - deltaX,
            pool.reserveY - deltaY,
            pool.totalLiquidity - deltaLiquidity,
            abi.decode(getPoolParams(poolId), (LogNormalParams))
        );

        valid = -(EPSILON) < invariant && invariant < EPSILON;
    }

    /// @inheritdoc IStrategy
    function validateSwap(
        address,
        uint256 poolId,
        IDFMM.Pool calldata pool,
        bytes memory data
    )
        public
        view
        returns (
            bool valid,
            int256 invariant,
            uint256 deltaX,
            uint256 deltaY,
            uint256 deltaLiquidity,
            bool isSwapXForY
        )
    {
        LogNormalParams memory params =
            abi.decode(getPoolParams(poolId), (LogNormalParams));

        (deltaX, deltaY, deltaLiquidity, isSwapXForY) =
            abi.decode(data, (uint256, uint256, uint256, bool));

        if (isSwapXForY) {
            invariant = LogNormalLib.tradingFunction(
                pool.reserveX + deltaX,
                pool.reserveY - deltaY,
                pool.totalLiquidity + deltaLiquidity,
                params
            );
        } else {
            invariant = LogNormalLib.tradingFunction(
                pool.reserveX - deltaX,
                pool.reserveY + deltaY,
                pool.totalLiquidity + deltaLiquidity,
                params
            );
        }

        valid = -(EPSILON) < invariant && invariant < EPSILON;
    }

    /// @inheritdoc IStrategy
    function update(
        address sender,
        uint256 poolId,
        IDFMM.Pool calldata,
        bytes calldata data
    ) external onlyDFMM {
        if (sender != internalParams[poolId].controller) revert InvalidSender();
        LogNormalLib.LogNormalUpdateCode updateCode =
            abi.decode(data, (LogNormalLib.LogNormalUpdateCode));

        if (updateCode == LogNormalLib.LogNormalUpdateCode.SwapFee) {
            internalParams[poolId].swapFee = LogNormalLib.decodeFeeUpdate(data);
        } else if (updateCode == LogNormalLib.LogNormalUpdateCode.Width) {
            (uint256 targetWidth, uint256 targetTimestamp) =
                LogNormalLib.decodeWidthUpdate(data);
            internalParams[poolId].width.set(targetWidth, targetTimestamp);
        } else if (updateCode == LogNormalLib.LogNormalUpdateCode.Mean) {
            (uint256 targetMean, uint256 targetTimestamp) =
                LogNormalLib.decodeMeanUpdate(data);
            internalParams[poolId].mean.set(targetMean, targetTimestamp);
        } else if (updateCode == LogNormalLib.LogNormalUpdateCode.Controller) {
            internalParams[poolId].controller =
                LogNormalLib.decodeControllerUpdate(data);
        } else {
            revert InvalidUpdateCode();
        }
    }

    /// @inheritdoc IStrategy
    function getPoolParams(uint256 poolId) public view returns (bytes memory) {
        LogNormalParams memory params;

        params.width = internalParams[poolId].width.actualized();
        params.mean = internalParams[poolId].mean.actualized();
        params.swapFee = internalParams[poolId].swapFee;

        return abi.encode(params);
    }

    /// @inheritdoc IStrategy
    function computeSwapConstant(
        uint256 poolId,
        bytes memory data
    ) public view returns (int256) {
        (uint256 reserveX, uint256 reserveY, uint256 totalLiquidity) =
            abi.decode(data, (uint256, uint256, uint256));
        return LogNormalLib.tradingFunction(
            reserveX,
            reserveY,
            totalLiquidity,
            abi.decode(getPoolParams(poolId), (LogNormalParams))
        );
    }
}
