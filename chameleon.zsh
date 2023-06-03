prompt_chameleon_refresh() {
  prompt_chameleon_color='#ff0000'
  zle reset-prompt
}

prompt_chameleon_precmd() {
  TMOUT=1
  trap "prompt_chameleon_refresh" SIGALRM
}

prompt_chameleon_setup() {
  typeset -g prompt_chameleon_color='#006688'
  PROMPT='%F{$prompt_chameleon_color}> %f'
  add-zsh-hook precmd prompt_chameleon_precmd
}

prompt_chameleon_setup "$@"
