function ff
    set file (
        fdfind --type f --hidden --follow --exclude .git |
        fzf \
            --preview 'batcat --color=always --style=numbers,header,grid --line-range=:500 {}' \
            --preview-window 'right:60%'
    )

    if test -n "$file"
        nvim "$file"
    end
end
