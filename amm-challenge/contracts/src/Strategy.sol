// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AMMStrategyBase} from "./AMMStrategyBase.sol";
import {TradeInfo} from "./IAMMStrategy.sol";

/// @title SimpleFixed55
/// @notice Best-performing configuration so far (~379 edge over 200 sims)
contract Strategy is AMMStrategyBase {
    uint256 private constant FEE_BPS = 55;

    function afterInitialize(uint256, uint256) external pure override returns (uint256, uint256) {
        uint256 fee = bpsToWad(FEE_BPS);
        return (fee, fee);
    }

    function afterSwap(TradeInfo calldata) external pure override returns (uint256, uint256) {
        uint256 fee = bpsToWad(FEE_BPS);
        return (fee, fee);
    }

    function getName() external pure override returns (string memory) {
        return "SimpleFixed55";
    }
}
