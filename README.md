# claude-plugins

Claude Code plugin marketplace by [atknatk](https://github.com/atknatk).

## Install

Inside Claude Code:

```
/plugin marketplace add atknatk/claude-plugins
```

## Plugins

| Plugin | Description | Install |
| --- | --- | --- |
| [code-review](plugins/code-review/) | Multi-session code review with auto-fix loop | `/plugin install code-review@atknatk` |

Run `/reload-plugins` after installing.

## Manage

```
/plugin marketplace update atknatk        # Fetch latest plugins
/plugin uninstall <plugin>@atknatk        # Remove a plugin
/plugin marketplace remove atknatk        # Remove marketplace
```

## License

MIT
