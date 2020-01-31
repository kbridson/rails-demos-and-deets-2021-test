# sdflem.zsh-theme

PROMPT='
%{$FG[248]%}[%{$FG[248]%}%n%{$FG[248]%}@%{$FG[248]%}%m%{$FG[248]%}:%{$fg[cyan]%}%~/%{$FG[248]%}$(git_prompt_info)%{$FG[248]%}]
%# %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔"
