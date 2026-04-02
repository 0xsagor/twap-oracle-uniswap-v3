# Time-Weighted Average Price (TWAP) Oracle

A professional-grade implementation for on-chain price discovery. Standard spot prices are easily manipulated via flash loans; this TWAP Oracle solves that by averaging the price over a set period (e.g., 30 minutes). It leverages Uniswap V3's geometric mean price accumulators, eliminating the need for external maintenance bots.

## Core Features
* **Manipulation Resistance:** Averages price over time, making it exponentially expensive to skew the result.
* **Geometric Mean:** Uses Uniswap V3's `observations` for mathematically sound averaging.
* **Low Maintenance:** Does not require "poking" or periodic updates; it reads directly from the pool's history.
* **Flat Architecture:** Single-directory layout for the Oracle consumer and the price calculation library.

## Logic Flow
1. **Request:** Consumer calls `getPrice` for a specific token pair.
2. **Fetch:** Oracle queries the Uniswap V3 Pool for two points in time ($t_1$ and $t_2$).
3. **Calculate:** The difference in tick accumulators is divided by the time delta.
4. **Result:** Returns the time-weighted average tick, converted to a human-readable price.

## Setup
1. `npm install`
2. Deploy `StaticTWAPOracle.sol` with the Uniswap V3 Pool address.
