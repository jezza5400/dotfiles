# =============================================================================
# Powerlevel10k Instant Prompt
# =============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# Oh My Zsh Configuration
# =============================================================================
# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# =============================================================================
# Update Behavior
# =============================================================================
# Update automatically without asking and show logs. Check once per day
zstyle ':omz:update' mode auto
zstyle ':omz:update' verbose default
zstyle ':omz:update' frequency 1

# =============================================================================
# Plugin Configuration
# =============================================================================
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# User Configuration
# =============================================================================
# run-help setup
autoload -Uz run-help
# Make "help <cmd>" work
alias help=run-help

# Language environment
export LANG=en_AU.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='micro'
if [[ -n $SSH_CONNECTION ]]; then
    export VISUAL='micro'
else
	export VISUAL='code -w'
fi

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

# Sets default less options so Git only opens the pager for long outputs
export LESS=FRX

# Pico SDK
export PICO_SDK_PATH="$HOME/pico/pico-sdk"
export PICO_EXAMPLES_PATH="$HOME/pico/pico-examples"
# export PICO_EXTRAS_PATH="$HOME/pico/pico-extras"
# export PICO_PLAYGROUND_PATH="$HOME/pico/pico-playground"

# =============================================================================
# PATH configuration
# =============================================================================

export PNPM_HOME="$HOME/.local/share/pnpm"

path=(
	$HOME/bin
	$HOME/.local/bin
	/usr/local/bin
	$path
	$HOME/.dotnet/tools
	"$PNPM_HOME"
)

export PATH

# =============================================================================
# Powerlevel10k Theme Customization
# =============================================================================
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
