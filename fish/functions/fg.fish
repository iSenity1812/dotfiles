function fg
    set file (
        git ls-files |
        fzf --preview 'batcat --color=always --style=numbers,header,grid {}'
    )

    if test -n "$file"
        nvim "$file"
    end
end
