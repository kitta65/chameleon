# chameleon

A simple command prompt for zsh, which gradually changes the color.

[![asciicast](https://asciinema.org/a/oFwQslgRXYEIExsv1QBdEV0HK.svg)](https://asciinema.org/a/oFwQslgRXYEIExsv1QBdEV0HK)

## Install

> **Note**
> It is optional but recommended to install [zsh-async](https://github.com/mafredri/zsh-async) before.

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
# .zshrc
autoload -U promptinit; promptinit
prompt chameleon
```

## Inspired by

* [pure](https://github.com/sindresorhus/pure)
