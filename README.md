# pi-workspace-id

A tiny wrapper for [`pi`](https://github.com/badlogic/pi-mono) that keeps session history stable across directory renames/moves by using a persistent workspace ID.

## Why

Pi stores sessions by working-directory path by default. That is simple and fast, but if your project path changes (rename/move), Pi treats it as a different workspace with a different session bucket.

That means these workflows effectively **BREAK** with default Pi after a path change:

- `pi -c` / `--continue`
- `pi -r` / `--resume` and in-app `/resume`
- `/tree` (branch/message history and labels)
- `/fork` and `/new` continuity
- `--session <partial-uuid>` lookup
- `/session` metadata/path reporting
- follow-on session workflows like `/export` and `/share`

This wrapper introduces a stable workspace key in:

```text
<workspace>/.pi/workspace-id
```

Then it always runs pi with:

```bash
pi --session-dir ~/.pi/agent/workspaces/<workspace-id>
```

## Features

- Works in git and non-git directories
- Auto-creates a workspace ID if missing
- Uses git root when available
- For non-git folders, reuses nearest ancestor with `.pi/workspace-id`
- Falls back to current directory if no root marker exists

## Install

### Option A: zsh plugin (recommended)

This repo ships a plugin file: `pi-workspace-id.plugin.zsh`.

#### Oh My Zsh

```bash
ln -s ~/web-jm/pi-workspace-id ~/.oh-my-zsh/custom/plugins/pi-workspace-id
```

Then add to your plugins list in `~/.zshrc`:

```zsh
plugins+=(pi-workspace-id)
```

#### zinit

```zsh
zinit light <your-github-user>/pi-workspace-id
```

By default, the plugin aliases:

```zsh
pi='piw'
pi-raw='command pi'
```

If you want only PATH wiring (no aliases), set this before loading the plugin:

```zsh
export PIW_NO_ALIASES=1
```

### Option B: direct install script

```bash
git clone <this-repo-url>
cd pi-workspace-id
./install.sh
```

Restart shell, or run:

```bash
source ~/.zshrc   # or ~/.bashrc
```

## Usage

If plugin aliases are enabled, use `pi` as usual (it maps to `piw`).

```bash
pi
pi -c
pi -r
pi "help me refactor this"
```

You can always call `piw` directly too:

```bash
piw -c
piw -r
```

### Session history in Pi

This wrapper improves both **continue** and **history browsing** workflows because the session bucket is stable per workspace ID.

```text
pi -c       # continue most recent session in this workspace
pi -r       # open resume picker for this workspace
/resume     # inside pi: pick another session file
/tree       # inside pi: browse branch/message history of current session
```

Because `piw` always passes `--session-dir` based on `.pi/workspace-id`, these workflows stay intact even if you rename/move directories.

### Helper commands

```bash
piw init [path]   # initialize workspace-id in path (or current dir)
piw id            # print effective workspace id
piw dir           # print effective session dir
piw info          # print root, id file, id, and session dir
piw --help
```

### Manual aliases (if not using plugin aliases)

If you are not using the plugin, add these to your shell profile:

```bash
alias pi='piw'
alias pi-raw='command pi'
```

Use `pi-raw` if you ever want original, unwrapped pi behavior.

## Configuration

Set custom base directory for workspace session buckets:

```bash
export PI_WORKSPACES_DIR="$HOME/.pi/agent/workspaces"
```

Default:

```text
~/.pi/agent/workspaces
```

## Notes

- This wrapper does not modify pi session format.
- Existing old path-based session files remain valid and can still be opened via `pi -r` / `pi --session`.
- For teams using non-git folders, committing `.pi/workspace-id` can keep workspace identity stable across machines.

## License

MIT
