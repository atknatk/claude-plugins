---
description: 'Initialize Dark Factory in a new project — creates .dark-factory/ directory, config.yaml, backlog, governance docs, and example holdout.'
user-invocable: true
---

# /dark-factory:init

Initialize the Dark Factory autonomous pipeline in the current project.

## Usage

```
/dark-factory:init [project-name] [github-repo]
```

## What It Creates

```
.dark-factory/
├── config.yaml          — Project-specific configuration (risk factors, ship model, etc.)
├── backlog.md           — Task queue
├── governance.md        — Governance tier rules and risk scoring
├── failure-patterns.md  — Known failure patterns and recovery strategies
├── holdouts/            — Holdout scenario directory (add your .holdout.yaml files here)
│   └── example.holdout.yaml
└── sessions/            — Session artifacts (auto-created by pipeline)
```

## Process

1. Copy templates from `${CLAUDE_PLUGIN_ROOT}/templates/dark-factory.init/` to `.dark-factory/`
2. Update `config.yaml` with project name and GitHub repo (from arguments or prompt)
3. Create holdouts directory with an example holdout scenario
4. Create sessions directory
5. Print setup instructions

## After Init

1. Edit `.dark-factory/config.yaml` to customize risk factors for your project
2. Write holdout scenarios in `.dark-factory/holdouts/<layer>/*.holdout.yaml`
3. Run `/dark-factory:readiness` to check your project's readiness score
4. Run `/dark-factory:factory start` to begin autonomous development
