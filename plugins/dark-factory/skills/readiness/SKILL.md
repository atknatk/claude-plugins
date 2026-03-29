---
description: 'Evaluate project readiness for Dark Factory autonomous development. Scores 8 axes and produces a scorecard.'
user-invocable: true
---

# /dark-factory:readiness

Evaluate project readiness for Dark Factory autonomous development.

## Usage

```
/dark-factory:readiness [area]
```

## Process

1. Spawn the `readiness-auditor` agent
2. Agent evaluates 8 axes: build, test, lint, types, instructions, structure, CI/CD, self-heal
3. Returns a JSON scorecard and human-readable report

## Output

Dark Factory eligible: overall score >= 75.

Projects scoring below 75 will receive specific recommendations for improvement.
