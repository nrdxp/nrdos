declare -a dirs
dirs+=( $(while read line; do line=${(Q)line}; [[ -d $line ]] && echo $line; done < $HOME/.cache/zsh-cdr/recent-dirs) )
dirs+=( $(fd --exact-depth=3 -t d . $HOME/git) )

printf "%s\n" ${(u)dirs[@]%/}
