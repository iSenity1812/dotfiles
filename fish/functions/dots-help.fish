function dots-help
    printf '%s\n' \
        '# Dotfiles Help' \
        '' \
        '## Files & Search' \
        'ff     → fuzzy find file bằng fd + fzf, preview bằng batcat, mở bằng nvim' \
        'fv     → fuzzy find file, preview rồi xem bằng batcat' \
        'fcd    → fuzzy find folder, preview tree bằng eza, rồi cd vào folder' \
        'fg     → fuzzy find file đang được Git track, rồi mở bằng nvim' \
        'fr     → search nội dung bằng rg + fzf, mở đúng file + line trong nvim' \
        '' \
        '## eza / Listing' \
        'ls     → list file với icons' \
        'la     → list cả hidden files với icons' \
        'll     → long listing + hidden + Git status' \
        'l      → long listing + hidden' \
        'lt     → tree depth 2' \
        '' \
        '## eza / Tree' \
        'tree   → full tree + icons + folders first' \
        'tree2  → tree depth 2' \
        'tree3  → tree depth 3' \
        'treea  → tree gồm cả hidden files' \
        'treeg  → tree Git-friendly, gồm hidden nhưng bỏ gitignored files' \
        '' \
        '## bat' \
        'cat    → batcat không paging' \
        'bat    → batcat với line numbers + header + grid' \
        'batp   → batcat plain, không decoration' \
        '' \
        '## Search tools' \
        grep \
        find \
        'rg (ripgrep)' \
        fdfind \
        '' \
        '## Git' \
        'gs     → git status' \
        'ga     → git add' \
        'gc     → git commit' \
        'gp     → git push' \
        'gl     → compact graphical git log' \
        '' \
        '## GitHub CLI' \
        'pr     → gh pr' \
        'issue  → gh issue' \
        '' \
        '## Navigation' \
        '..     → cd ..' \
        '...    → cd ../..' \
        '....   → cd ../../..' \
        'c      → clear' \
        '' \
        '## tmux' \
        'Ctrl+a |   → split left / right' \
        'Ctrl+a -   → split top / bottom' \
        'Ctrl+a x   → close current pane' \
        'Ctrl+a d   → detach session' \
        'Ctrl+a r   → reload tmux config' \
        '' \
        '## Git' \
        'gl       → log graph + oneline + decorate + all branches' \
        'gds      → diff của những thay đổi đã staged' \
        'gbr      → branch list, sort theo commit gần nhất' \
        'glf FILE → lịch sử thay đổi của một file' \
        'glp FILE → patch history đầy đủ của một file' \
        'gps TEXT → tìm commit đã thêm/xóa một đoạn text' \
        'gcontrib → contributors theo số commit' \
        'fglog    → browse commits bằng fzf + preview diff' \
        'fpr      → browse Pull Requests bằng fzf, preview chi tiết, Enter xem terminal, Ctrl+O mở web' \
        'fissue   → browse Issues bằng fzf, preview chi tiết, Enter xem terminal, Ctrl+O mở web' \
        | batcat --language=markdown --style=plain --paging=never
end
