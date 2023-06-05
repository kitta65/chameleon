prompt_chameleon_gradation() {
  local temp=$prompt_chameleon_color

  local -A rgb
  rgb=(
    r 0x${temp:1:2}
    g 0x${temp:3:2}
    b 0x${temp:5:2}
  )

  local increment=30
  if (( rgb[r] == 255 )) && (( rgb[g] < 255 )) && (( rgb[b] == 0 )); then
    # red -> yellow
    rgb[g]=$((rgb[g] + increment))
    rgb[g]=$((rgb[g] < 255 ? rgb[g] : 255))
  elif (( rgb[r] > 0 )) && (( rgb[g] == 255 )) && (( rgb[b] == 0 )); then
    # yellow -> green
    rgb[r]=$((rgb[r] - increment))
    rgb[r]=$((rgb[r] < 0 ? 0 : rgb[r]))
  elif (( rgb[r] == 0 )) && (( rgb[g] == 255 )) && (( rgb[b] < 255 )); then
    # yellow -> aqua
    rgb[b]=$((rgb[b] + increment))
    rgb[b]=$((rgb[b] < 255 ? rgb[b] : 255))
  elif (( rgb[r] == 0 )) && (( rgb[g] > 0 )) && (( rgb[b] == 255 )); then
    # aqua -> blue
    rgb[g]=$((rgb[g] - increment))
    rgb[g]=$((rgb[g] < 0 ? 0 : rgb[g]))
  elif (( rgb[r] < 255 )) && (( rgb[g] == 0 )) && (( rgb[b] == 255 )); then
    # blue -> purple
    rgb[r]=$((rgb[r] + increment))
    rgb[r]=$((rgb[r] < 255 ? rgb[r] : 255))
  elif (( rgb[r] == 255 )) && (( rgb[g] == 0 )) && (( rgb[b] > 0 )); then
    # purple -> red
    rgb[b]=$((rgb[b] - increment))
    rgb[b]=$((rgb[b] < 0 ? 0 : rgb[b]))
  fi

  for key in ${(k)rgb}; do
    printf -v "rgb[$key]" "%02x" $rgb[$key]
  done
  prompt_chameleon_color='#'${rgb[r]}${rgb[g]}${rgb[b]}
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
