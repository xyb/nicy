autoload -Uz add-zsh-hook
add-zsh-hook -d preexec nicy_runtime_before
add-zsh-hook -d precmd nicy_runtime_after

NICY_RUNTIME_LAST_SECONDS=$SECONDS
nicy_runtime_before() {
    NICY_RUNTIME_LAST_SECONDS=$SECONDS
}
nicy_runtime_after() {
    NICY_RUNTIME_SECONDS=-1
    if [[ -n "$NICY_RUNTIME_LAST_SECONDS" ]]; then
        (( NICY_RUNTIME_SECONDS=SECONDS-NICY_RUNTIME_LAST_SECONDS ))
        unset NICY_RUNTIME_LAST_SECONDS
    fi
}
add-zsh-hook preexec nicy_runtime_before
add-zsh-hook precmd nicy_runtime_after

nicy_prompt() {
    PROMPT=$(nicy --exit-status=$? --jobs=$(jobs -r | wc -l) --run-seconds=$NICY_RUNTIME_SECONDS)
}
add-zsh-hook precmd nicy_prompt
