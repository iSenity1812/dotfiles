# eza
alias ls='eza --icons'
alias la='eza -a --icons'
alias ll='eza -lah --icons --git'
alias lt='eza --tree --icons --level=2'
alias l='eza -lah --icons'

# eza tree
alias tree='eza --tree --icons --group-directories-first'
alias tree2='eza --tree --icons --group-directories-first --level=2'
alias tree3='eza --tree --icons --group-directories-first --level=3'
alias treea='eza --tree -a --icons --group-directories-first'
alias treeg='eza --tree -a --icons --git --git-ignore --group-directories-first --level=3'

# bat
alias cat='batcat --paging=never'
alias batp='batcat --plain'
alias bat='batcat --style=numbers,header,grid'

# ripgrep
#alias grep='rg'

# fd
#alias find='fd'

# git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# gh
alias pr='gh pr'
alias issue='gh issue'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# clear
alias c='clear'

# github
# log đẹp, dễ đọc
alias gl='git log --graph --decorate --oneline --all'

# diff staged
alias gds='git diff --staged'

# xem branch theo thời gian commit gần nhất
alias gbr='git branch --sort=-committerdate --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) %(color:green)(%(committerdate:relative))%(color:reset) %(contents:subject)"'

# xem commit nào thay đổi một file
alias glf='git log --follow --stat --'

# xem lịch sử patch của một file
alias glp='git log -p --follow --'

# tìm commit chứa một đoạn text trong diff
alias gps='git log -S'

# xem contributors
alias gcontrib='git shortlog -sn --all'
