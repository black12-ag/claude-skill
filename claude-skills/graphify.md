---
name: graphify
description: Update and query the Graphify knowledge graph for the current project. Use when asked to refresh the graph, explore architecture, find god nodes, or answer codebase structure questions. Trigger on: "update graph", "refresh graphify", "show architecture", "what does graphify say about X".
---

# Graphify Skill

Graphify builds an AST-based knowledge graph of the codebase. Use it to explore architecture and keep the graph current after code changes.

## How to use

**Update the graph after code changes:**
```bash
python3 -c "from graphify.watch import _rebuild_code; from pathlib import Path; _rebuild_code(Path('.'))"
```
Or if graphify is installed globally:
```bash
graphify update .
```

**Explore the graph:**
1. Open `graphify-out/graph.html` in a browser for the interactive visual graph
2. Read `graphify-out/GRAPH_REPORT.md` for god nodes and community structure
3. If `graphify-out/wiki/index.md` exists, navigate it for file-by-file summaries

## Rules
- Always check `graphify-out/GRAPH_REPORT.md` before answering architecture questions
- After modifying source files, run `graphify update .` to keep the graph current
- Use the wiki index instead of reading raw files when it exists — saves tokens
