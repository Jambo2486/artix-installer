#!/bin/bash

get_input(){
    local escape_char=$(printf "\u1b")
    local char
    read -rsn1 char
    if [[ $char == $escape_char ]]; then
        read -rsn4 -t 0.001 char
    else
        return $char ;
    case $char in
        "[A") return "up" ;;
        "[B") return "down" ;;
        "[D") return "left" ;;
        "[C") return "right" ;;
        *) return 0 ;;
    esac
}

get_input()