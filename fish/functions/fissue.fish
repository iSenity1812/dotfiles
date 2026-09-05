function fissue
    set issue (
        CLICOLOR_FORCE=1 gh issue list \
            --limit 100 \
            --json number,title,author,labels \
            --template '{{range .}}{{printf "%v\t" .number}}{{color "cyan" (printf "#%v" .number)}}{{"\t"}}{{color "bold" .title}}{{"\t"}}{{color "green" (printf "@%s" .author.login)}}{{"\t"}}{{range .labels}}{{color "magenta" .name}}{{" "}}{{end}}{{"\n"}}{{end}}' |
        fzf \
            --ansi \
            --delimiter='\t' \
            --with-nth=2,3,4,5 \
            --border=rounded \
            --prompt=' Issue ❯ ' \
            --pointer='▶' \
            --header='Enter: view   Ctrl+O: browser   Esc: quit' \
            --preview='CLICOLOR_FORCE=1 gh issue view {1} \
                --json number,title,state,author,labels,assignees,url,body \
                --template '\''
{{color "cyan" (printf "#%v" .number)}}  {{color "bold" .title}}

{{if eq .state "OPEN"}}{{color "green" "● OPEN"}}{{else}}{{color "red" "● CLOSED"}}{{end}}

{{color "yellow" "Author"}}     {{color "green" (printf "@%s" .author.login)}}
{{color "yellow" "Labels"}}     {{range .labels}}{{color "magenta" .name}}{{"  "}}{{end}}
{{color "yellow" "Assignees"}}  {{range .assignees}}{{color "cyan" (printf "@%s" .login)}}{{"  "}}{{end}}

{{color "blue" .url}}

{{color "bold" "Description"}}
{{.body}}
'\''' \
            --preview-window='right:65%:wrap:border-left' \
            --bind='ctrl-o:execute-silent(gh issue view {1} --web)'
    )

    if test -n "$issue"
        set number (string split \t $issue)[1]
        gh issue view $number
    end
end
