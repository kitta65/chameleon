prompt_chameleon_gradation() {
  local rgb=$prompt_chameleon_color

  local red16=${rgb:1:2}
  local green16=${rgb:3:2}
  local blue16=${rgb:5:2}

  local red10=$(echo "obase=10; ibase=16; $red16" | bc)
  local green10=$(echo "obase=10; ibase=16; $green16" | bc)
  local blue10=$(echo "obase=10; ibase=16; $blue16" | bc)

  local diff=30
  if (( red10 == 255 )) && (( green10 < 255 )) && (( blue10 == 0 )); then
    # red -> yellow
    green10=$((green10 + diff))
    green10=$((green10 < 255 ? green10 : 255))
  elif (( red10 > 0 )) && (( green10 == 255 )) && (( blue10 == 0 )); then
    # yellow -> green
    red10=$((red10 - diff))
    red10=$((red10 < 0 ? 0 : red10))
  elif (( red10 == 0 )) && (( green10 == 255 )) && (( blue10 < 255 )); then
    # yellow -> aqua
    blue10=$((blue10 + diff))
    blue10=$((blue10 < 255 ? blue10 : 255))
  elif (( red10 == 0 )) && (( green10 > 0 )) && (( blue10 == 255 )); then
    # aqua -> blue
    green10=$((green10 - diff))
    green10=$((green10 < 0 ? 0 : green10))
  elif (( red10 < 255 )) && (( green10 == 0 )) && (( blue10 == 255 )); then
    # blue -> purple
    red10=$((red10 + diff))
    red10=$((red10 < 255 ? red10 : 255))
  elif (( red10 == 255 )) && (( green10 == 0 )) && (( blue10 > 0 )); then
    # purple -> red
    blue10=$((blue10 - diff))
    blue10=$((blue10 < 0 ? 0 : blue10))
  fi

  red16=0$(echo "obase=16; ibase=10; $red10" | bc) # 1 -> 01, 00 -> 001
  green16=0$(echo "obase=16; ibase=10; $green10" | bc) # 1 -> 01, 00 -> 001
  blue16=0$(echo "obase=16; ibase=10; $blue10" | bc) # 1 -> 01, 00 -> 001
  red16=${red16: -2} # 001 -> 01
  green16=${green16: -2} # 001 -> 01
  blue16=${blue16: -2} # 001 -> 01
  prompt_chameleon_color='#'${red16}${green16}${blue16}
}

prompt_chameleon_refresh() {
  prompt_chameleon_gradation
  zle reset-prompt

  if $prompt_chameleon_async; then
    async_job chameleon sleep $prompt_chameleon_interval
  fi
}

prompt_chameleon_precmd() {
  TMOUT=1
  # if trap was set in prompt_chameleon_setup, it would not work.
  trap "prompt_chameleon_refresh" SIGALRM
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
