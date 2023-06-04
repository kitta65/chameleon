prompt_chameleon_gradation() {
  prompt_chameleon_color='#000000'
}

prompt_chameleon_refresh() {
  prompt_chameleon_gradation
  zle reset-prompt
  async_job chameleon sleep $prompt_chameleon_interval
}

prompt_chameleon_setup() {
  typeset -g prompt_chameleon_color='#FF0000'
  PROMPT='%F{$prompt_chameleon_color}❯ %f'
  prompt_opts=(percent subst)

  typeset -g prompt_chameleon_interval=0.5
  async_init
  async_start_worker chameleon
  async_register_callback chameleon prompt_chameleon_refresh
  async_job chameleon sleep $prompt_chameleon_interval
}
prompt_chameleon_setup "$@"
