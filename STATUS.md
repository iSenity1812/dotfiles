# Dotfiles Status

Current terminal development setup before starting Oh My Pi configuration.

## Completed

### Terminal

* Ghostty configured
* tmux configured
* Fish shell configured

### CLI tools

* eza
* bat / batcat
* fd
* ripgrep
* fzf
* GitHub CLI
* Neovim / LazyVim

## Fish configuration

### `conf.d`

* `aliases.fish` — aliases for eza, bat, Git, navigation, etc.
* `env.fish` — environment variables such as `EDITOR` and ripgrep config path
* `fzf.fish` — shared fzf defaults and UI settings

### Functions

* `ff` — find a file with fd + fzf, preview with bat, open in Neovim
* `fv` — find and view a file with bat
* `fcd` — fuzzy-find a directory and cd into it
* `fg` — fuzzy-find Git-tracked files
* `fr` — search file contents with ripgrep and jump to the matching line
* `fglog` — browse Git commits with fzf and preview diffs
* `fpr` — browse GitHub pull requests, preview details, open in terminal or browser
* `fissue` — browse GitHub issues, preview details, open in terminal or browser
* `dots-help` — quick reference for custom commands

## Tool-specific configuration

* `bat/config`
* `ripgrep/ripgreprc`
* `ghostty/config.ghostty`
* `.tmux.conf`

## Bootstrap

`bootstrap.sh` currently:

* creates dotfile symlinks
* backs up existing configs
* safely skips already-correct symlinks
* checks required CLI tools
* can be run repeatedly without intentionally overwriting the tracked configs

## Current repository

```text
.
├── bat/
│   └── config
├── fish/
│   ├── conf.d/
│   │   ├── aliases.fish
│   │   ├── env.fish
│   │   └── fzf.fish
│   ├── functions/
│   │   ├── dots-help.fish
│   │   ├── fcd.fish
│   │   ├── ff.fish
│   │   ├── fg.fish
│   │   ├── fglog.fish
│   │   ├── fissue.fish
│   │   ├── fpr.fish
│   │   ├── fr.fish
│   │   └── fv.fish
│   └── config.fish
├── ghostty/
│   └── config.ghostty
├── ripgrep/
│   └── ripgreprc
├── .tmux.conf
├── bootstrap.sh
├── README.md
└── STATUS.md
```

## Next

Next configuration target:

**Oh My Pi (`omp.sh`)**

Planned work:

1. inspect current OMP configuration
2. add declarative OMP config to dotfiles
3. add Fish completion
4. design useful agent roles
5. evaluate skills, extensions, and MCP only where useful

