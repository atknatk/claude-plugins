---
description: 'Show Dark Factory observability dashboard — session metrics, quality scores, Ralph loop status, backlog summary.'
user-invocable: true
---

# /dark-factory:dashboard

Show the Dark Factory observability dashboard.

## Usage

```
/dark-factory:dashboard [--json] [--days N]
```

## Process

Run the dashboard script:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/dashboard.sh" $ARGUMENTS
```

## Options

- `--json`: Output in JSON format (for programmatic consumption)
- `--days N`: Show data from the last N days (default: 7)
