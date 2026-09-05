set -gx FZF_DEFAULT_COMMAND 'fdfind --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

set -gx FZF_DEFAULT_OPTS "
    --height=80%
    --layout=reverse
    --border=rounded
    --info=inline
    --prompt='❯ '
    --pointer='▶'
    --marker='✓'
    --preview-window=right:60%:border-left
    --bind='ctrl-u:preview-page-up'
    --bind='ctrl-d:preview-page-down'
    --bind='ctrl-f:preview-half-page-down'
    --bind='ctrl-b:preview-half-page-up'
    --bind='ctrl-/:toggle-preview'
"
