function fv
    set file (
        fdfind --type f --hidden --exclude .git |
        fzf --preview 'batcat --color=always --style=numbers,header,grid {}'
    )

    if test -n "$file"
        batcat "$file"
    end
end
