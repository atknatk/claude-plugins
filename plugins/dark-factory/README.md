# Dark Factory Plugin

Autonomous AI development pipeline for Claude Code. Ships code autonomously with governance tiers, holdout validation, and satisfaction testing.

## Features

- **Ralph Wiggum Loop**: Fresh-context-per-task autonomous execution
- **Governance Tiers**: T0 (auto-ship) to T4 (blocked) based on risk scoring
- **Holdout Validation**: Agent-invisible behavioral tests
- **Satisfaction Judge**: Two-pass adversarial quality evaluation
- **Readiness Auditor**: 8-axis project readiness scoring
- **Pipeline Doctor**: Self-healing on pipeline failures

## Install

```
/plugin install dark-factory@atknatk
```

## Quick Start

```bash
# Initialize in your project
/dark-factory:init MyProject owner/repo

# Edit config for your project
# .dark-factory/config.yaml

# Write holdout scenarios
# .dark-factory/holdouts/<layer>/*.holdout.yaml

# Check readiness
/dark-factory:readiness

# Start autonomous loop
/dark-factory:factory start
```

## Skills

| Skill | Usage | Description |
|-------|-------|-------------|
| `/dark-factory:factory` | `start\|stop\|status\|sync\|run\|validate\|backlog` | Control the Dark Factory |
| `/dark-factory:task` | `<spec-or-description>` | Run a single task through the pipeline |
| `/dark-factory:readiness` | `[area]` | Evaluate project readiness (8 axes) |
| `/dark-factory:satisfaction` | `<spec>` | Run quality evaluation |
| `/dark-factory:dashboard` | `[--json] [--days N]` | Show observability metrics |
| `/dark-factory:validate` | `<session-id>` | Inspect a completed session |
| `/dark-factory:init` | `[name] [repo]` | Initialize Dark Factory in a project |

## Project Configuration

Each project needs a `.dark-factory/config.yaml`:

```yaml
project_name: "MyProject"
github_repo: "owner/repo"
ship_model: "pr-creation"    # direct-commit | pr-creation | pr-label
holdout_dir: ".dark-factory/holdouts"
backlog_file: ".dark-factory/backlog.md"
backlog_format: "issue+spec"  # spec-only | issue+spec
governance_ceiling: "T1"      # Ralph loop only processes up to this tier

risk_factors:
  - pattern: "auth|login|session"
    score: 30
    label: "Auth/Security code"
  - pattern: "payment|billing"
    score: 30
    label: "Payment processing"
```

## Architecture

```
GitHub Issues -> sync-backlog -> backlog.md -> ralph.sh (loop)
                                                  |
                                            run-task.sh
                                                  |
                                 +---------------------------+
                                 | 1. Implementation (SDD+TDD)|
                                 | 2. Holdout validation       |
                                 | 3. Satisfaction judge        |
                                 | 4. Governance tier           |
                                 | 5. Ship (PR/merge/label)     |
                                 +---------------------------+
                                                  |
                                 GitHub Issue + PR labels updated
```

## License

MIT
