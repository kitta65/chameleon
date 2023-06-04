# chameleon

A simple command prompt for zsh, which gradually changes the color.

## Install

Clone this repo somewhere you like (e.g. `$HOME/.zsh/chameleon`).

```sh
git clone https://github.com/kitta65/chameleon.git ~/.zsh/chameleon
```

Add the path of the cloned repo to `$fpath`.

```sh
# .zshrc
fpath+=("$HOME/.zsh/chameleon")
```

## Initialize

```sh
autoload -U promptinit; promptinit
prompt chameleon
```
