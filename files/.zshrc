source ~/.zplug/init.zsh

autoload -U compinit; compinit
autoload -Uz colors; colors

zstyle ':completion:*' list-colors ''

# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2

source ~/.zsh-git-prompt/zshrc.sh
GIT_PROMPT_EXECUTABLE="haskell"
PROMPT='%B%m%~%b$(git_super_status) %# '

zplug "bobthecow/git-flow-completion", from:github

# git status
do_enter() {
    if [[ -n $BUFFER ]]; then
        zle accept-line
        return $status
    fi

    echo
    if [[ -d .git ]]; then
        if [[ -n "$(git status --short)" ]]; then
            git status
        fi
    else
        # do nothing
        :
    fi

    zle reset-prompt
}
zle -N do_enter
bindkey '^m' do_enter

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

