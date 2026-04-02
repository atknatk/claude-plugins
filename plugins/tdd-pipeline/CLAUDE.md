# tdd-pipeline Plugin

Generic TDD pipeline agents for test-driven development workflows.

## Agents

- **tester** — Writes tests FIRST (TDD). Reads the spec, creates tests and skeleton interfaces, leaves them failing for the developer.
- **reviewer** — Quality gate. Reviews PRs against a comprehensive checklist: code quality, security, architecture, coverage >= 80%.
- **ui-polish** — Final stage. Applies visual polish, micro-interactions, theme consistency, and performance optimization. Cannot change business logic or break tests.

## Usage

All agents expect the consuming project to have a `CLAUDE.md` that documents:

- Tech stack and frameworks
- Test framework and conventions
- Directory structure
- Coding standards
- Any project-specific quality requirements (multi-tenant, feature flags, etc.)

The agents read `CLAUDE.md` first and adapt their behavior to the project's stack.
