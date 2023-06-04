prompt_chameleon_setup() {
  typeset -g prompt_chameleon_color='#FF0000'
  PROMPT='%F{$prompt_chameleon_color}❯ %f'
  prompt_opts=(percent subst)
}
prompt_chameleon_setup "$@"
