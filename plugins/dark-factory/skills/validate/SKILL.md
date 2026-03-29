---
description: 'Validate a completed Dark Factory session — show governance decision, metrics, and recommended actions.'
user-invocable: true
---

# /dark-factory:validate

Validate a completed Dark Factory session.

## Usage

```
/dark-factory:validate <session-id>
```

## Process

Run the validation script:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/validate-session.sh" $ARGUMENTS
```

Shows governance tier, satisfaction score, holdout results, and recommended next actions.
