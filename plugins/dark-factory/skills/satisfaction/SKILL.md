---
description: 'Run two-pass adversarial LLM quality evaluation on a completed feature implementation.'
user-invocable: true
---

# /dark-factory:satisfaction

Run the satisfaction judge — a two-pass adversarial LLM evaluation of implementation quality.

## Usage

```
/dark-factory:satisfaction <spec-or-description>
```

## Process

1. Spawn the `satisfaction-judge` agent
2. Pass 1: Five-dimension evaluation (correctness, completeness, code quality, test quality, architecture)
3. Pass 2: Adversarial review (try to break the implementation)
4. Final score: composite + adversarial adjustments

## Scoring

- **80+**: Production-ready
- **70-79**: Acceptable with minor issues
- **50-69**: Needs improvement
- **<50**: Blocked — significant issues found
