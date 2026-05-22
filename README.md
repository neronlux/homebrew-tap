# neronlux/homebrew-tap

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Homebrew tap for **[ntech-team-kit](https://github.com/neronlux/ntech-team-kit)** — a portable collection of high-quality skills, agents, commands, and rules for [OpenCode](https://opencode.ai).

## Installation

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

## Usage

Once installed, you get access to powerful OpenCode commands and skills such as:

- `/review-and-ship` — Review changes, run tests, commit, and open a PR
- `/loop-on-ci` — Watch CI and automatically fix failures until green
- `ntech-team-kit doctor` — Health checks for your setup

See the full list of capabilities in the [main documentation](https://github.com/neronlux/ntech-team-kit#quick-start).

## Updating

```bash
brew update
brew upgrade ntech-team-kit
```

## Requirements

- [OpenCode](https://opencode.ai)
- [GitHub CLI (`gh`)](https://cli.github.com/) (authenticated)

## Troubleshooting

Run the built-in doctor command:

```bash
ntech-team-kit doctor
```

This will check that OpenCode and `gh` are installed and properly configured.

## License

MIT License — see the [main project](https://github.com/neronlux/ntech-team-kit) for details.
