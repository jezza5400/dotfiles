# --- Powerlevel10k Instant Prompt ---
# Must stay at the very top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# --- Oh My Zsh Configuration ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"


# --- Plugin Configuration ---
source /usr/share/fzf/key-bindings.zsh

plugins=(
	git
	fzf
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

zstyle ':omz:update' mode auto
zstyle ':omz:update' verbose default
zstyle ':omz:update' frequency 1


# --- User Configuration ---
autoload -Uz run-help

alias help=run-help
alias gdd='git -c core.pager="delta --side-by-side" diff'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export LANG=en_AU.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='micro'
if [[ -n $SSH_CONNECTION ]]; then
	export VISUAL='micro'
else
	export VISUAL='code -w'
fi

# Less defaults
export LESS=FRX

# Environment variables
export PICO_SDK_PATH="$HOME/pico/pico-sdk"
export PICO_EXAMPLES_PATH="$HOME/pico/pico-examples"
# export PICO_EXTRAS_PATH="$HOME/pico/pico-extras"
# export PICO_PLAYGROUND_PATH="$HOME/pico/pico-playground"


# --- PATH configuration ---
export PNPM_HOME="$HOME/.local/share/pnpm"

path=(
	"$PNPM_HOME/bin"
	"$PNPM_HOME"
	$HOME/bin
	$HOME/.local/bin
	$HOME/.dotnet/tools
	/usr/local/bin
	$path
)

typeset -Ux path
typeset -Ux fpath


# --- Powerlevel10k Prompt Theme ---
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
