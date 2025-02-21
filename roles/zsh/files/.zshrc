export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=""
HIST_STAMPS="dd.mm.yyyy"

plugins=(
  aliases
  command-not-found
  eza
  git
  vi-mode
)

source $ZSH/oh-my-zsh.sh

# ── User Configuration ────────────────────────────────────────────────

# Use Vi key bindings
bindkey -v

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

# Oh My Posh
eval "$(oh-my-posh init zsh --config "${HOME}/.config/oh-my-posh/config.yml")"

# fastfetch
if [[ $(tty) == *"pts"* ]]; then
  fastfetch
fi

# ── Aliases ───────────────────────────────────────────────────────────
alias eza="eza --icons --group-directories-first --octal-permissions"
alias v="nvim"
alias udc="docker compose pull && docker compose up -d"
