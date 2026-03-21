# claude-plugins

Claude Code plugin marketplace by [atknatk](https://github.com/atknatk). A collection of plugins for code review, development tools, and automation.

## Install

Inside Claude Code, run:

```
/plugin marketplace add atknatk/claude-plugins
```

Then install any plugin you want:

```
/plugin install code-review@atknatk
/reload-plugins
```

## Plugins

### code-review

Multi-session code review with auto-fix loop. Reviewer runs in isolated `claude -p` sessions for unbiased review, fixer stays in the current session to preserve project context.

```
Current Claude Session (fixer, persistent context)
     |
     v
  claude -p "review diff"  <-- New session each time (no bias)
     |
     |-- PASS -> Done
     '-- FAIL -> Fix in current session -> Re-review (new session)
                 Max N iterations
```

#### Commands

```
/code-review:review              # Review current changes
/code-review:review staged       # Review only staged changes
/code-review:review-fix          # Review + fix loop (max 3 iterations)
/code-review:review-fix 5        # Review + fix loop (max 5 iterations)
```

#### How It Works

**`/code-review:review`** — Runs `git diff HEAD`, sends it to a new `claude -p` session with the review prompt. Returns `STATUS: PASS/FAIL` with issues and fix suggestions. Each review is an isolated session with no bias.

**`/code-review:review-fix`** — Review + fix loop:

1. **Review** (new `claude -p` session): Reviews current diff, returns issues
2. **Fix** (current session): Fixes reported issues using Edit/Write tools
3. **Re-review** (another new `claude -p` session): Checks if fixes are clean
4. Repeats until `STATUS: PASS` or max iterations reached

The reviewer is always a fresh session (no bias). The fixer is the current session (preserves project context).

#### Terminal Usage

```bash
# Clone and use scripts directly
git clone https://github.com/atknatk/claude-plugins.git
cd claude-plugins/plugins/code-review/scripts

# Single review
./review.sh
./review.sh --staged

# Review + fix loop
./review-fix.sh        # max 3 iterations
./review-fix.sh 5      # max 5 iterations

# Git pre-commit hook (per project)
./install-git-hook.sh
git commit -m "..."              # Review runs automatically
CLAUDE_REVIEW_SKIP=1 git commit  # Skip review
```

#### Pre-commit Hook

Reviews staged changes with `claude -p` on every commit. Only flags CRITICAL issues (confidence >= 90). Blocks commit if critical issues found.

```bash
# Install hook in any project
~/.claude/plugins/cache/atknatk/code-review/*/scripts/install-git-hook.sh
```

#### Environment Variables

| Variable | Default | Description |
| --- | --- | --- |
| `CLAUDE_REVIEW_MODEL` | `opus` | Model for review sessions |
| `CLAUDE_FIX_MODEL` | `opus` | Model for fix sessions (terminal mode) |
| `CLAUDE_REVIEW_SKIP` | `0` | Set to `1` to skip pre-commit review |

#### Project Rules

The plugin reads `CLAUDE.md` from the project root and includes it in every review prompt. Project-specific rules override general review rules.

## Structure

```
.claude-plugin/marketplace.json                     # Marketplace catalog
plugins/
  code-review/
    .claude-plugin/plugin.json                       # Plugin metadata
    agents/reviewer.md                               # In-session reviewer agent
    commands/review.md                               # /code-review:review
    commands/review-fix.md                           # /code-review:review-fix
    prompts/review-prompt.md                         # Review prompt template
    prompts/fix-prompt.md                            # Fix prompt template
    scripts/review.sh                                # Terminal: single review
    scripts/review-fix.sh                            # Terminal: review+fix loop
    scripts/git-pre-commit-review.sh                 # Git pre-commit hook
    scripts/install-git-hook.sh                      # Hook installer
```

## Adding a New Plugin

1. Create `plugins/your-plugin/.claude-plugin/plugin.json`:
   ```json
   {
     "name": "your-plugin",
     "description": "What it does",
     "version": "1.0.0",
     "author": { "name": "atknatk" }
   }
   ```
2. Add commands, agents, skills, hooks under `plugins/your-plugin/`
3. Add entry to `.claude-plugin/marketplace.json`:
   ```json
   { "name": "your-plugin", "source": "./plugins/your-plugin" }
   ```
4. Push and run `/plugin marketplace update atknatk` inside Claude Code

## Manage

```
/plugin marketplace update atknatk              # Update marketplace
/plugin install <plugin>@atknatk                # Install a plugin
/plugin uninstall <plugin>@atknatk              # Uninstall a plugin
/plugin marketplace remove atknatk              # Remove marketplace
/reload-plugins                                  # Reload after changes
```

## License

MIT
