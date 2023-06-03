prompt_chameleon_refresh() {
  prompt_chameleon_color='#ff0000'
  zle reset-prompt

  if $prompt_chameleon_async; then
    async_job chameleon sleep 3
  fi
}

prompt_chameleon_precmd() {
  TMOUT=1
  # if trap was set in prompt_chameleon_setup, it would not work.
  trap "prompt_chameleon_refresh" SIGALRM
}

prompt_chameleon_setup() {
  typeset -g prompt_chameleon_color='#006688'
  PROMPT='%F{$prompt_chameleon_color}> %f'

  typeset -g prompt_chameleon_async=false
  if command -v async_init > /dev/null; then
    prompt_chameleon_async=true
  fi

  if $prompt_chameleon_async; then
    async_init
    async_start_worker chameleon
    async_register_callback chameleon prompt_chameleon_refresh
    async_job chameleon sleep 3
  else
    echo async_init not found
    add-zsh-hook precmd prompt_chameleon_precmd_fallback
  fi
}

prompt_chameleon_setup "$@"
