function fpr
    set pr (
        CLICOLOR_FORCE=1 gh pr list \
            --limit 100 \
            --json number,title,headRefName,author \
            --template '{{range .}}{{printf "%v\t" .number}}{{color "cyan" (printf "#%v" .number)}}{{"\t"}}{{color "bold" .title}}{{"\t"}}{{color "magenta" .headRefName}}{{"\t"}}{{color "green" (printf "@%s" .author.login)}}{{"\n"}}{{end}}' |
        fzf \
            --ansi \
            --delimiter='\t' \
            --with-nth=2,3,4,5 \
            --border=rounded \
            --prompt=' PR ❯ ' \
            --pointer='▶' \
            --header='Enter: view   Ctrl+O: browser   Esc: quit' \
            --preview='CLICOLOR_FORCE=1 gh pr view {1} \
    --json number,title,state,author,headRefName,baseRefName,url,additions,deletions,changedFiles,body \
    --template '\''
{{color "cyan" (printf "#%v" .number)}}  {{color "bold" .title}}

{{if eq .state "OPEN"}}{{color "green" "● OPEN"}}{{else}}{{color "red" .state}}{{end}}

{{color "yellow" "Author"}}   @{{.author.login}}
{{color "yellow" "Branch"}}   {{color "magenta" .headRefName}} → {{.baseRefName}}
{{color "yellow" "Changes"}}  {{color "green" (printf "+%v" .additions)}} {{color "red" (printf "-%v" .deletions)}}  {{.changedFiles}} files

{{color "blue" .url}}

{{color "bold" "Description"}}
{{.body}}
'\''' \
            --preview-window='right:65%:wrap:border-left' \
            --bind='ctrl-o:execute-silent(gh pr view {1} --web)'
    )

    if test -n "$pr"
        set number (string split \t $pr)[1]
        gh pr view $number
    end
end
