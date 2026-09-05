function fcd
    set dir (
        fdfind --type d --hidden --exclude .git |
        fzf \
            --preview 'eza --tree --icons --level=2 {}'
    )

    if test -n "$dir"
        cd "$dir"
    end
end
