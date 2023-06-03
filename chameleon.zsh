prompt_chameleon_precmd() {
  echo "dummy precmd"
}

prompt_chameleon_setup() {
  typeset -g prompt_chameleon_color='#006688'
  PROMPT='%F{$prompt_chameleon_color}> %f'
  add-zsh-hook precmd prompt_chameleon_precmd
}

prompt_chameleon_setup "$@"
