# 0x94305 / Alex Nezlobin — AMM Design Notes

_Last updated: 2026-02-26_

## 1. Hook Timing (beforeSwap vs afterSwap)
- Repeated jokes that responsible AMM designers “prefer beforeSwap hooks” (Valentine’s Day tweet, 2026-02-14).
- Takeaway: optimize fee schedule before order execution to avoid purely reactive (afterSwap) fixes.

## 2. Retail vs Toxic Flow Trade-off
- Question (2026-02-10): “What is worse for LPs—getting hit by an arb swap of size X or missing an uninformed swap of size X?”
- Crowd wisdom (Dan Robinson, Rahul Jain, etc.): missing good flow can cost ~2× the fee revenue, whereas arb losses are roughly 1×.
- Design note: bias strategies toward capturing uninformed flow even at the cost of tolerating some arbitrage.

## 3. Flow Classification Inputs
- Replies highlighted key determinants: volatility σ, latency τ, fee f, liquidity depth D, and ability to discriminate flow (0xDeep, 2026-02-10).
- Application: maintain indicators for volatility regime, book freshness, and directional inventory when adjusting fees.

## 4. Block-Level Synchronization for Oracles / Unlocks
- Proposal (2026-01-26): waive base fee burn for the first <300k gas tx with no CALLs, so builders can post oracle/unlock data each block.
- Emphasizes need for cheap, deterministic top-of-block space so AMMs can refresh parameters synchronously.

## 5. General Attitude Toward AMM Fees
- “I will not set AMM fees in an afterSwap hook” (2026-02-12) — underscores preference for proactive rather than reactive fee logic.
- Encourages thinking of fee curves as planned policies rather than ad-hoc responses.

## 6. Meta Advice
- Dan Robinson (2026-02-08) praises Alex’s historical tweets as “actual alpha”; scraping them for GPT fine-tuning is suggested.
- Implication: treat Alex’s archive as a dataset of heuristics for dynamic-fee design.

---
_This document aggregates the tweets that Michael shared manually. When more historical posts become available, extend these sections with direct quotes or links._
