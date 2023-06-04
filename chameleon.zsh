prompt_chameleon_gradation() {
  local temp=$prompt_chameleon_color

  local -A rgb16
  rgb16=(
    r ${temp:1:2}
    g ${temp:3:2}
    b ${temp:5:2}
  )

  local -A rgb10
  rgb10=()
  for key in ${(k)rgb16}; do
    rgb10[$key]=$(echo "obase=10; ibase=16; $rgb16[$key]" | bc)
  done

  local increment=30
  if (( rgb10[r] == 255 )) && (( rgb10[g] < 255 )) && (( rgb10[b] == 0 )); then
    # red -> yellow
    rgb10[g]=$((rgb10[g] + increment))
    rgb10[g]=$((rgb10[g] < 255 ? rgb10[g] : 255))
  elif (( rgb10[r] > 0 )) && (( rgb10[g] == 255 )) && (( rgb10[b] == 0 )); then
    # yellow -> green
    rgb10[r]=$((rgb10[r] - increment))
    rgb10[r]=$((rgb10[r] < 0 ? 0 : rgb10[r]))
  elif (( rgb10[r] == 0 )) && (( rgb10[g] == 255 )) && (( rgb10[b] < 255 )); then
    # yellow -> aqua
    rgb10[b]=$((rgb10[b] + increment))
    rgb10[b]=$((rgb10[b] < 255 ? rgb10[b] : 255))
  elif (( rgb10[r] == 0 )) && (( rgb10[g] > 0 )) && (( rgb10[b] == 255 )); then
    # aqua -> blue
    rgb10[g]=$((rgb10[g] - increment))
    rgb10[g]=$((rgb10[g] < 0 ? 0 : rgb10[g]))
  elif (( rgb10[r] < 255 )) && (( rgb10[g] == 0 )) && (( rgb10[b] == 255 )); then
    # blue -> purple
    rgb10[r]=$((rgb10[r] + increment))
    rgb10[r]=$((rgb10[r] < 255 ? rgb10[r] : 255))
  elif (( rgb10[r] == 255 )) && (( rgb10[g] == 0 )) && (( rgb10[b] > 0 )); then
    # purple -> red
    rgb10[b]=$((rgb10[b] - increment))
    rgb10[b]=$((rgb10[b] < 0 ? 0 : rgb10[b]))
  fi

  for key in ${(k)rgb16}; do
    local hex=$(echo "obase=16; ibase=10; $rgb10[$key]" | bc) # 10 -> A
    hex=0$hex # A -> 0A, FF -> 0FF
    hex=${hex: -2} # 0FF -> FF
    rgb16[$key]=$hex
  done
  prompt_chameleon_color='#'${rgb16[r]}${rgb16[g]}${rgb16[b]}
}

prompt_chameleon_refresh() {
  prompt_chameleon_gradation
  zle reset-prompt

  if $prompt_chameleon_async; then
    async_job chameleon sleep $prompt_chameleon_interval
  fi
}

prompt_chameleon_precmd() {
  # if trap was set in prompt_chameleon_setup, it would not work.
  trap "prompt_chameleon_refresh" SIGALRM
  TMOUT=1
}

prompt_chameleon_setup() {
  typeset -g prompt_chameleon_color='#FF0000'
  PROMPT='%F{$prompt_chameleon_color}❯ %f'

  typeset -g prompt_chameleon_async=false
  if command -v async_init > /dev/null; then
    prompt_chameleon_async=true
  fi

  if $prompt_chameleon_async; then
    typeset -g prompt_chameleon_interval=0.1
    async_init
    async_start_worker chameleon
    async_register_callback chameleon prompt_chameleon_refresh
    async_job chameleon sleep $prompt_chameleon_interval
  else
    add-zsh-hook precmd prompt_chameleon_precmd
  fi
}

prompt_chameleon_setup "$@"
