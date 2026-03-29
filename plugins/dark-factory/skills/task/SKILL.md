---
description: 'Start a new development task through the Dark Factory pipeline. Analyzes task, classifies size, and routes to implementation.'
user-invocable: true
---

# /dark-factory:task

Start a new development task. Analyzes the task, classifies size, identifies affected areas, and routes to the correct pipeline with governance.

## Usage

```
/dark-factory:task <description or spec path>
```

## Process

1. **Analyze** the task using the task-analyzer agent
2. **Route** to the appropriate pipeline depth based on task size
3. **Execute** through the SDD+TDD pipeline
4. **Validate** with holdout + satisfaction testing
5. **Ship** based on governance tier decision

## Examples

```
/dark-factory:task Add user avatar upload to the profile page
/dark-factory:task docs/specs/backend-notifications.intent.md
/dark-factory:task Fix the login redirect bug on mobile
```

## Arguments

- `$ARGUMENTS`: The task description (natural language) or path to an intent-spec file (`.intent.md`)

## Pipeline

For the given task, run:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/run-task.sh" $ARGUMENTS
```
