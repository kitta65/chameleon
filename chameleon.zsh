prompt_chameleon_setup () {
  typeset -g prompt_chameleon_color='#006688'
  PROMPT='%F{$prompt_chameleon_color}> %f'
}

prompt_chameleon_setup "$@"
