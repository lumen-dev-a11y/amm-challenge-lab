// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AMMStrategyBase} from "./AMMStrategyBase.sol";
import {TradeInfo} from "./IAMMStrategy.sol";

contract Strategy is AMMStrategyBase {
    // slots[0] bidFee
    // slots[1] askFee
    // slots[2] lastTimestamp
    // slots[3] lastSide (1 buy / 0 sell)
    // slots[4] riskScore (WAD)

    function afterInitialize(uint256, uint256) external override returns (uint256 bidFee, uint256 askFee) {
        uint256 base = bpsToWad(30);
        slots[0] = base;
        slots[1] = base;
        slots[2] = 0;
        slots[3] = 0;
        slots[4] = 0;
        return (base, base);
    }

    function afterSwap(TradeInfo calldata t) external override returns (uint256 bidFee, uint256 askFee) {
        uint256 base = bpsToWad(30);
        uint256 maxExtra = bpsToWad(111);

        uint256 tradeRatio = 0;
        if (t.reserveY > 0) {
            tradeRatio = wdiv(t.amountY, t.reserveY);
        }

        uint256 lastTs = slots[2];
        uint256 dt = lastTs == 0 ? 999999 : (t.timestamp > lastTs ? t.timestamp - lastTs : 0);

        bool isBuy = t.isBuy;
        bool lastIsBuy = slots[3] == 1;
        bool switched = (lastTs != 0) && (isBuy != lastIsBuy);

        uint256 risk = slots[4];

        uint256 decay = bpsToWad(4);
        if (risk > decay) risk -= decay;
        else risk = 0;

        if (tradeRatio > WAD / 50) risk += bpsToWad(4);   // >2%
        if (tradeRatio > WAD / 20) risk += bpsToWad(14);  // >5%
        if (dt <= 2 && switched) risk += bpsToWad(24);

        if (risk > WAD) risk = WAD;

        uint256 dyn = base + wmul(risk, maxExtra);

        uint256 skew = wmul(tradeRatio, bpsToWad(40));
        if (skew > bpsToWad(12)) skew = bpsToWad(12);

        if (isBuy) {
            bidFee = clampFee(dyn + skew);
            askFee = dyn > skew ? clampFee(dyn - skew) : clampFee(base);
        } else {
            askFee = clampFee(dyn + skew);
            bidFee = dyn > skew ? clampFee(dyn - skew) : clampFee(base);
        }

        slots[0] = bidFee;
        slots[1] = askFee;
        slots[2] = t.timestamp;
        slots[3] = isBuy ? 1 : 0;
        slots[4] = risk;

        return (bidFee, askFee);
    }

    function getName() external pure override returns (string memory) {
        return "auto_104";
    }
}
