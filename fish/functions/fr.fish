function fr
    set result (
        rg --line-number --no-heading --color=never . |
        fzf \
            --delimiter : \
            --preview 'batcat --color=always --highlight-line {2} --line-range {2}: {1}'
    )

    if test -n "$result"
        set file (string split : $result)[1]
        set line (string split : $result)[2]

        nvim +$line "$file"
    end
end
