# neronlux/homebrew-tap

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Formulas in this tap:

- **[yes-dev-linux](https://github.com/neronlux/yes-dev-linux)** — auto-approve Chrome's "Allow remote debugging?" prompt on Linux (below)
- **[ntech-team-kit](https://github.com/neronlux/ntech-team-kit)** — portable skills, agents, commands, and rules for [OpenCode](https://opencode.ai) ([docs](#ntech-team-kit))

## yes-dev-linux

A Linux engine that watches for Chrome's **"Allow remote debugging?"**
consent dialog and approves it automatically, so parallel automation
clients never block on a human click. Detection is AT-SPI; the click is
a portal screenshot → button finder → dedicated absolute uinput pointer.
Runs as a systemd user service and is boot-safe.

```bash
brew tap neronlux/tap
brew install yes-dev-linux
```

Quick start (watch first — clicking is off by default):

```bash
yes-dev-linux --observe        # watch only
yes-dev-linux --enable-click   # auto-approve
```

Distro packages are required (Homebrew can't ship python3-gi):

```bash
sudo apt install python3-gi gir1.2-atspi-2.0 python3-pil python3-evdev python3-dbus
```

Setup, systemd service, and reboot survival are documented in the
project [README](https://github.com/neronlux/yes-dev-linux#staying-up-reboot-crashes-updates);
contributing and testing in
[CONTRIBUTING.md](https://github.com/neronlux/yes-dev-linux/blob/main/CONTRIBUTING.md).

## ntech-team-kit

**[ntech-team-kit](https://github.com/neronlux/ntech-team-kit)** — a portable collection of high-quality skills, agents, commands, and rules for [OpenCode](https://opencode.ai).

### Installation

```bash
brew tap neronlux/tap
brew install ntech-team-kit
```

After installation, set up the kit in your OpenCode configuration:

```bash
ntech-team-kit install
```

### Recommended first steps

```bash
ntech-team-kit doctor      # Verify your environment is ready
ntech-team-kit status      # See what is currently installed
```

### Usage

Once installed, you get access to powerful OpenCode commands and skills such as:

- `/review-and-ship` — Review changes, run tests, commit, and open a PR
- `/loop-on-ci` — Watch CI and automatically fix failures until green
- `ntech-team-kit doctor` — Health checks for your setup

See the full list of capabilities in the [main documentation](https://github.com/neronlux/ntech-team-kit#quick-start).

### Updating

```bash
brew update
brew upgrade ntech-team-kit
```

### Requirements

- [OpenCode](https://opencode.ai)
- [GitHub CLI (`gh`)](https://cli.github.com/) (authenticated)

### Troubleshooting

Run the built-in doctor command:

```bash
ntech-team-kit doctor
```

This will check that OpenCode and `gh` are installed and properly configured.

## License

MIT License — see the [main project](https://github.com/neronlux/ntech-team-kit) for details.
