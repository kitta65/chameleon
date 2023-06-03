prompt_chameleon_change_color() {
  local red16=${prompt_chameleon_color:0:2}
  local green16=${prompt_chameleon_color:3:2}
  local blue16=${prompt_chameleon_color:5:2}
  local red10=$(echo "obase=10; ibase=16; $red16" | bc)
  red10=$((red10 + 10))
  red10=$((red10 < 255 ? red10 : 0))
  red16=0$(echo "obase=16; ibase=10; $red10" | bc) # 1 -> 01, 00 -> 001
  red16=${red16: -2} # 001 -> 01
  prompt_chameleon_color='#'${red16}${green16}${blue16}
}

prompt_chameleon_refresh() {
  prompt_chameleon_change_color
  echo $prompt_chameleon_color

  if $prompt_chameleon_async; then
    async_job chameleon sleep 1
  fi
}

prompt_chameleon_precmd() {
  TMOUT=1
  # if trap was set in prompt_chameleon_setup, it would not work.
  trap "prompt_chameleon_refresh" SIGALRM
}

prompt_chameleon_setup() {
  typeset -g prompt_chameleon_color='#000000'
  PROMPT='%F{$prompt_chameleon_color}> %f'

  typeset -g prompt_chameleon_async=false
  if command -v async_init > /dev/null; then
    prompt_chameleon_async=true
  fi

  if $prompt_chameleon_async; then
    async_init
    async_start_worker chameleon
    async_register_callback chameleon prompt_chameleon_refresh
    async_job chameleon sleep 1
    echo initialized
  else
    add-zsh-hook precmd prompt_chameleon_precmd
  fi
}

prompt_chameleon_setup "$@"
