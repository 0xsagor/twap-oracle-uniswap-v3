// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import "@uniswap/v3-core/contracts/libraries/FullMath.sol";

/**
 * @title StaticTWAPOracle
 * @dev Fetches TWAP from Uniswap V3 Pools.
 */
contract StaticTWAPOracle {
    address public immutable pool;
    uint32 public immutable twapInterval;

    constructor(address _pool, uint32 _twapInterval) {
        pool = _pool;
        twapInterval = _twapInterval;
    }

    /**
     * @dev Gets the TWAP price for Token0 in terms of Token1.
     */
    function getTwapPrice() external view returns (uint256 price) {
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = twapInterval;
        secondsAgos[1] = 0;

        (int56[] memory tickCumulatives, ) = IUniswapV3Pool(pool).observe(secondsAgos);

        int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];
        int24 arithmeticMeanTick = int24(tickCumulativesDelta / int32(twapInterval));

        // Price = 1.0001^tick
        uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(arithmeticMeanTick);
        uint256 priceX96 = FullMath.mulDiv(sqrtPriceX96, sqrtPriceX96, 1 << 192);
        
        return priceX96;
    }
}
