# dotfiles

Personal Ubuntu development environment.

## Stack

* Ghostty
* Fish
* tmux
* eza
* bat / batcat
* fd
* ripgrep
* fzf
* GitHub CLI
* Neovim

## Structure

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
│   │   ├── fr.fish
│   │   └── fv.fish
│   └── config.fish
├── ghostty/
│   └── config.ghostty
├── ripgrep/
│   └── ripgreprc
└── .tmux.conf
```

## Useful commands

```text
ff      find file + preview + open in Neovim
fv      find file + preview with bat
fcd     find directory + cd
fg      find Git-tracked file
fr      search file contents + jump to exact line
fglog   browse Git commits with fzf and preview diffs

dots-help
        show the full dotfiles command reference
```

## Notes

These dotfiles are symlinked from this repository into their expected locations under `$HOME` and `~/.config`.

The setup is intentionally small and focused on terminal productivity.

