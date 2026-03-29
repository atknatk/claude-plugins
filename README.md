# claude-plugins

Everva Claude Code Plugin Marketplace by [atknatk](https://github.com/atknatk).

## Install

Inside Claude Code:

```
/plugin marketplace add atknatk/claude-plugins
```

## Plugins

| Plugin | Description | Install |
| --- | --- | --- |
| [code-review](plugins/code-review/) | Multi-session code review with auto-fix loop | `/plugin install code-review@atknatk` |
| [dark-factory](plugins/dark-factory/) | Autonomous AI development pipeline with governance, holdouts, and satisfaction testing | `/plugin install dark-factory@atknatk` |

Run `/reload-plugins` after installing.

## Dark Factory Quick Start

```bash
# 1. Install the plugin
/plugin install dark-factory@atknatk

# 2. Initialize Dark Factory in your project
/dark-factory:init MyProject owner/repo

# 3. Check readiness
/dark-factory:readiness

# 4. Start autonomous development
/dark-factory:factory start
```

See [dark-factory README](plugins/dark-factory/README.md) for full documentation.

## Manage

```
/plugin marketplace update atknatk        # Fetch latest plugins
/plugin uninstall <plugin>@atknatk        # Remove a plugin
/plugin marketplace remove atknatk        # Remove marketplace
```

## License

MIT
