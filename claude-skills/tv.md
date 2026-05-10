---
name: tv
description: Quick TradingView analysis shortcut. Use when user types /tv or "check [stock/crypto]". Runs technical analysis, sentiment, and screener via TradingView MCP.
---

# TradingView Quick Analysis

When user types `/tv <symbol>` or `/tv`, use the TradingView MCP tools to:

1. Get technical analysis for the symbol (RSI, MACD, moving averages, recommendation)
2. Get current sentiment if available
3. Show a brief summary: trend direction, key levels, signal (BUY/SELL/NEUTRAL)

If no symbol given, ask: "Which stock or crypto? (e.g. AAPL, BTCUSDT, ETHUSDT)"

Keep the output short and scannable — use a table or bullet list.
