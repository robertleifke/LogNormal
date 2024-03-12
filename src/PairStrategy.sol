/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { IStrategy, IDFMM } from "src/interfaces/IStrategy.sol";
import "forge-std/console2.sol";

/**
 * @title Strategy base contract for DFMM.
 * @author Primitive
 */
abstract contract PairStrategy is IStrategy {
    /// @inheritdoc IStrategy
    address public immutable dfmm;

    int256 public constant EPSILON = 20;

    constructor(address dfmm_) {
        dfmm = dfmm_;
    }

    /// @dev Restricts the caller to the DFMM contract.
    modifier onlyDFMM() {
        if (msg.sender != address(dfmm)) revert NotDFMM();
        _;
    }

    /// @inheritdoc IStrategy
    function validateAllocate(
        address,
        uint256 poolId,
        IDFMM.Pool memory pool,
        bytes calldata data
    )
        external
        view
        virtual
        returns (
            bool valid,
            int256 invariant,
            uint256[] memory deltas,
            uint256 deltaLiquidity
        )
    {
        (uint256 maxDeltaX, uint256 maxDeltaY, uint256 deltaL) =
            abi.decode(data, (uint256, uint256, uint256));

        // TODO: This is a small trick because `deltaLiquidity` cannot be used
        // directly, let's fix this later.
        deltaLiquidity = deltaL;
        deltas = _computeAllocateDeltasGivenDeltaL(
            deltaLiquidity, pool, getPoolParams(poolId)
        );

        if (deltas[0] > maxDeltaX) {
            console2.log("erring on dx");
            revert DeltaError(maxDeltaX, deltas[0]);
        }

        if (deltas[1] > maxDeltaY) {
            console2.log("erring on dy");
            revert DeltaError(maxDeltaY, deltas[1]);
        }

        pool.reserves[0] += deltas[0];
        pool.reserves[1] += deltas[1];

        invariant = tradingFunction(
            pool.reserves,
            pool.totalLiquidity + deltaLiquidity,
            getPoolParams(poolId)
        );

        valid = -(EPSILON) < invariant && invariant < EPSILON;
    }

    /// @inheritdoc IStrategy
    function validateDeallocate(
        address,
        uint256 poolId,
        IDFMM.Pool memory pool,
        bytes calldata data
    )
        external
        view
        virtual
        returns (
            bool valid,
            int256 invariant,
            uint256[] memory deltas,
            uint256 deltaLiquidity
        )
    {
        (uint256 minDeltaX, uint256 minDeltaY, uint256 deltaL) =
            abi.decode(data, (uint256, uint256, uint256));

        deltaLiquidity = deltaL;
        deltas = _computeDeallocateDeltasGivenDeltaL(
            deltaLiquidity, pool, getPoolParams(poolId)
        );

        if (minDeltaX > deltas[0]) {
            revert DeltaError(minDeltaX, deltas[0]);
        }

        if (minDeltaY > deltas[1]) {
            revert DeltaError(minDeltaY, deltas[1]);
        }

        pool.reserves[0] -= deltas[0];
        pool.reserves[1] -= deltas[1];

        invariant = tradingFunction(
            pool.reserves,
            pool.totalLiquidity - deltaLiquidity,
            getPoolParams(poolId)
        );

        valid = -(EPSILON) < invariant && invariant < EPSILON;
    }

    function validateSwap(
        address,
        uint256 poolId,
        IDFMM.Pool memory pool,
        bytes memory data
    )
        external
        view
        virtual
        returns (
            bool valid,
            int256 invariant,
            uint256 tokenInIndex,
            uint256 tokenOutIndex,
            uint256 amountIn,
            uint256 amountOut,
            uint256 deltaLiquidity
        )
    {
        bytes memory params = getPoolParams(poolId);

        (tokenInIndex, tokenOutIndex, amountIn, amountOut, deltaLiquidity) =
            abi.decode(data, (uint256, uint256, uint256, uint256, uint256));

        pool.reserves[tokenInIndex] += amountIn;
        pool.reserves[tokenOutIndex] -= amountOut;

        invariant = tradingFunction(
            pool.reserves, pool.totalLiquidity + deltaLiquidity, params
        );

        valid = -(EPSILON) < invariant && invariant < EPSILON;
    }

    function getPoolParams(uint256 poolId)
        public
        view
        virtual
        returns (bytes memory);

    function tradingFunction(
        uint256[] memory reserves,
        uint256 totalLiquidity,
        bytes memory params
    ) public view virtual returns (int256);

    function _computeAllocateDeltasGivenDeltaL(
        uint256 deltaLiquidity,
        IDFMM.Pool memory pool,
        bytes memory data
    ) internal view virtual returns (uint256[] memory);

    function _computeDeallocateDeltasGivenDeltaL(
        uint256 deltaLiquidity,
        IDFMM.Pool memory pool,
        bytes memory data
    ) internal view virtual returns (uint256[] memory);
}
