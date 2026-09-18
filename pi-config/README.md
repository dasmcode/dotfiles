# Pi configuration

Declarative global Pi configuration for this dotfiles repository.

This setup manages:

- `settings.json`
- local extensions, including Leaf Markdown rendering
- `zentui.json`
- pi-permission-system configuration
- pinned Pi package versions
- Leaf installation when Leaf is not already on `PATH`

It intentionally does **not** manage sessions or credentials.

## Install

Install Pi first, then run:

```bash
./install.sh
```

The script creates symlinks into `~/.pi/agent/`, installs the pinned packages,
and installs Leaf if needed. Existing managed files/directories are moved to a
timestamped `.backup.*` path before they are replaced.

Credentials should be configured separately with `pi auth` or environment
variables. Sessions remain local to each machine.
