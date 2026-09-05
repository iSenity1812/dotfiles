function fglog
    set commit (
        git log --oneline --decorate --color=always --all |
        fzf \
            --ansi \
            --no-sort \
            --preview 'git show --color=always {1}' \
            --preview-window=right:65%
    )

    if test -n "$commit"
        set hash (string split ' ' $commit)[1]
        git show --color=always $hash | less -R
    end
end
