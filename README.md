# Everva Claude Code Plugins

Marketplace for [Claude Code](https://claude.ai/code) plugins by [Everva](https://github.com/everva).

## Installation

### Step 1: Add the Marketplace

Open Claude Code (CLI, VS Code, or JetBrains) and run:

```bash
/plugin marketplace add everva/claude-plugins
```

This registers the Everva marketplace so you can install any plugin from it.

### Step 2: Install a Plugin

```bash
/plugin install dark-factory@everva    # Autonomous AI pipeline
/plugin install mobile-agents@everva   # iOS HIG + Android M3 specialists
/plugin install tdd-pipeline@everva    # TDD tester + reviewer + UI polish
/plugin install code-review@everva     # Code review with auto-fix
```

### Step 3: Reload

```bash
/reload-plugins
```

That's it. The plugin's skills, agents, and hooks are now available in your Claude Code session.

## Available Plugins

| Plugin | Description | Skills | Install |
| --- | --- | --- | --- |
| [dark-factory](plugins/dark-factory/) | Autonomous AI development pipeline with governance tiers, holdout validation, satisfaction testing, and Ralph Wiggum loop | `/dark-factory:factory`, `/dark-factory:task`, `/dark-factory:readiness`, `/dark-factory:dashboard`, `/dark-factory:init` | `/plugin install dark-factory@everva` |
| [mobile-agents](plugins/mobile-agents/) | iOS and Android UI specialist agents — HIG compliance, Material Design 3, accessibility gates | Agents: `ios-ui-specialist`, `android-ui-specialist` | `/plugin install mobile-agents@everva` |
| [tdd-pipeline](plugins/tdd-pipeline/) | TDD pipeline agents — test-first tester, code reviewer, UI polish | Agents: `tester`, `reviewer`, `ui-polish` | `/plugin install tdd-pipeline@everva` |
| [code-review](plugins/code-review/) | Multi-session code review with isolated reviewer sessions and auto-fix loop | `/code-review:review`, `/code-review:review-fix` | `/plugin install code-review@everva` |

## Lego Architecture

Plugins are composable building blocks. Pick what your project needs:

```text
Full-stack mobile project:        Backend-only project:       iOS-only app:
  dark-factory                      dark-factory                mobile-agents
  mobile-agents                     tdd-pipeline                tdd-pipeline
  tdd-pipeline                      code-review                 code-review
  + project-specific agents         + project-specific agents
```

Plugin agents are **generic** — they read your project's `CLAUDE.md` for context. Override any agent by placing a same-named `.md` file in your project's `.claude/agents/` directory.

| Layer | Plugin | What it provides |
| --- | --- | --- |
| Pipeline & Governance | `dark-factory` | Ralph loop, holdout validation, satisfaction judge, governance tiers, rate limiting, circuit breaker |
| Mobile Quality | `mobile-agents` | iOS HIG compliance, Android Material Design 3, accessibility gates |
| TDD & Review | `tdd-pipeline` | Test-first tester, code reviewer, UI polish agent |
| Code Review | `code-review` | Isolated review sessions, auto-fix loop |

## Quick Start: Dark Factory

```bash
# 1. Install
/plugin install dark-factory@everva

# 2. Initialize in your project (creates .dark-factory/ directory)
/dark-factory:init MyProject owner/repo

# 3. Edit risk factors for your project
#    .dark-factory/config.yaml

# 4. Write holdout scenarios (agent-invisible behavioral tests)
#    .dark-factory/holdouts/<layer>/*.holdout.yaml

# 5. Check project readiness score
/dark-factory:readiness

# 6. Run a single task through the full pipeline
/dark-factory:task docs/specs/my-feature.intent.md

# 7. Start the autonomous Ralph Wiggum loop
/dark-factory:factory start 10 8    # 10 tasks, 8 hours max
```

See [Dark Factory README](plugins/dark-factory/README.md) for full documentation.

## Quick Start: Code Review

```bash
# 1. Install
/plugin install code-review@everva

# 2. Review current changes
/code-review:review

# 3. Review + auto-fix loop (max 3 iterations)
/code-review:review-fix
```

See [Code Review README](plugins/code-review/README.md) for full documentation.

## Quick Start: Mobile Agents

```bash
# 1. Install
/plugin install mobile-agents@everva

# 2. Agents are now available for spawning
# ios-ui-specialist — HIG compliance, VoiceOver, Dynamic Type
# android-ui-specialist — Material Design 3, TalkBack, Compose patterns

# 3. Override for your project (optional)
# Place a custom version in .claude/agents/ios-ui-specialist.md
```

## Quick Start: TDD Pipeline

```bash
# 1. Install
/plugin install tdd-pipeline@everva

# 2. Agents are now available for spawning
# tester — writes tests FIRST (TDD), coverage >= 80%
# reviewer — code quality gates, security checklist
# ui-polish — cross-platform consistency, micro-interactions
```

## Using Plugins in Your Project

### Global Installation (all projects)

Add to `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "everva": {
      "source": { "source": "github", "repo": "everva/claude-plugins" }
    }
  },
  "enabledPlugins": {
    "dark-factory@everva": true,
    "mobile-agents@everva": true,
    "tdd-pipeline@everva": true,
    "code-review@everva": true
  }
}
```

### Project-Level Installation (shared with team)

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "everva": {
      "source": { "source": "github", "repo": "everva/claude-plugins" }
    }
  },
  "enabledPlugins": {
    "dark-factory@everva": true
  }
}
```

Commit this file to git so your team gets the plugin automatically.

### Local Development / Testing

Test a plugin from a local directory without installing:

```bash
claude --plugin-dir /path/to/claude-plugins/plugins/dark-factory
```

## Managing Plugins

```bash
# Update all plugins to latest version
/plugin marketplace update everva

# Disable a plugin (keeps data)
/plugin disable dark-factory@everva

# Re-enable
/plugin enable dark-factory@everva

# Uninstall (removes plugin, keeps data in $CLAUDE_PLUGIN_DATA)
/plugin uninstall dark-factory@everva

# Remove marketplace entirely
/plugin marketplace remove everva

# Validate plugin structure (for development)
/plugin validate .
```

## Creating a New Plugin

Want to add a plugin to this marketplace? See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT
