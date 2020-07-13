function nicy_prompt_command {
    PS1=$(nicy --exit-status=$? --jobs=$(jobs -r | wc -l) --run-seconds=$NICY_RUNTIME_SECONDS)
}
PROMPT_COMMAND="nicy_prompt_command"

# get run time of last command, $NICY_RUNTIME_SECONDS
nicy_runtime_event()
{
    # DEBUG to find who's calling this
    # echo runtime func called by: "$BASH_COMMAND"

    # skip all steps after PROMPT_COMMAND, for me, it's autojump
    if [ "$BASH_COMMAND" == "autojump_add_to_database" ]; then
        return
    fi

    # record the time before running command
    if [ $NICY_RUNTIME_COLLECTING = 0 ]; then
        NICY_RUNTIME_LAST_SECONDS=$SECONDS
        NICY_RUNTIME_SECONDS=-1
        NICY_RUNTIME_COLLECTING=1
    fi

    # catch the time after command exited and calling prompt command again.
    # then calculate total time.
    if [[ "$BASH_COMMAND" == "nicy_prompt_command" ]]; then
        NICY_RUNTIME_COLLECTING=0
        if [[ -n "${NICY_RUNTIME_LAST_SECONDS-}" ]]; then
            (( NICY_RUNTIME_SECONDS=SECONDS-NICY_RUNTIME_LAST_SECONDS ))
        fi
    fi
}
NICY_RUNTIME_COLLECTING=0
NICY_RUNTIME_LAST_SECONDS=$SECONDS
trap 'nicy_runtime_event "$_"' DEBUG
