# =============================================================================
# SECTION: Antidote Initialization
# =============================================================================

# Source antidote
source /usr/share/zsh-antidote/antidote.zsh

# Initialize antidote
antidote init > /dev/null

# Load bundled plugins from antidote
antidote load ~/.zsh_plugins.txt

source ~/.zprofile

# =============================================================================
# SECTION: Starship
# =============================================================================

eval "$(starship init zsh)"

# =============================================================================
# SECTION: Zoxide (Smart cd)
# =============================================================================

eval "$(zoxide init zsh)"

# =============================================================================
# SECTION: FZF Configuration
# =============================================================================

# Set FZF default height (use percentage for tmux compatibility)
export FZF_TMUX_HEIGHT="40%"

# Set default options for fzf
export FZF_DEFAULT_OPTS="--height $FZF_TMUX_HEIGHT"

# Set default preview commands
export FZF_PREVIEW_FILE_CMD="head -n 10"
export FZF_PREVIEW_DIR_CMD="ls"

# =============================================================================
# SECTION: Greeting Suppression
# =============================================================================

WELCOME=0

# =============================================================================
# SECTION: History
# =============================================================================

# Ensure history is persisted and shared across sessions.
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space

# =============================================================================
# SECTION: Auto-Tmux Spawning
# =============================================================================

if [[ -z "$TMUX" ]]; then
    # Unique-ish name: user + hostname + time + pid
    SESSION_NAME="$USER@(hostname)-$(date +%Y%m%d-%H%M%S)-$$"

    # Extremely unlikely, but avoid collision
    while tmux has-session -t "$SESSION_NAME" 2>/dev/null; do
        SESSION_NAME="$SESSION_NAME-x"
    done

    exec tmux new-session -s "$SESSION_NAME" \; set-option destroy-unattached on
fi

# =============================================================================
# SECTION: Aliases
# =============================================================================

# Use Neovim as the default editor, including for sudoedit.
export EDITOR="nvim"
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"

# eza aliases with group directories, icons, headers, and git status
alias ls='eza -l --group-directories-first --icons --git -a --no-permissions --no-user --no-time -h'

alias zc='ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" ANTHROPIC_AUTH_TOKEN=${GLM_API_KEY} ANTHROPIC_DEFAULT_OPUS_MODEL="GLM-4.7" ANTHROPIC_DEFAULT_SONNET_MODEL="GLM-4.7" ANTHROPIC_DEFAULT_HAIKU_MODEL="GLM-4.5-Air" claude'
alias dc='ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic" ANTHROPIC_AUTH_TOKEN=${DEEPSEEK_API_KEY} API_TIMEOUT_MS=3000000 ANTHROPIC_MODEL="deepseek-chat" ANTHROPIC_SMALL_FAST_MODEL="deepseek-chat" CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 claude'
alias mc='ANTHROPIC_BASE_URL="https://api.minimax.io/anthropic" ANTHROPIC_AUTH_TOKEN=${MINIMAX_PLAN_KEY} API_TIMEOUT_MS=3000000 ANTHROPIC_MODEL="MiniMax-M2.1" ANTHROPIC_SMALL_FAST_MODEL="MiniMax-M2.1" CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 claude'

# cd shortcut (zoxide provides the 'z' function)
# alias cd='z'

# Replace cat with bat (no paging for interactive use)
alias cat='bat --paging=never --theme=ansi'

# Edit root-owned files safely while keeping your user Neovim config.
alias snvim='sudoedit'

# pnpm
export PNPM_HOME="/home/estevao/.local/share/pnpm"
export PATH="$HOME/.local/bin:$PATH"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
