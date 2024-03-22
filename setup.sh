#!/bin/sh

user="Efgeen"
public="dotfiles"
private=".$public"
init="init.sh"

if [ -d "$HOME/$private" ]; then
    while true; do
        read -p "~/$private !404, force? (y/n): " force
        if [ "$force" = "y" ]; then
            break
        elif [ "$force" = "n" ]; then
            exit 0
        fi
    done
fi

if ! command -v git > /dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install git -y
fi

if [ ! -d "$public" ]; then
    if ! git clone "https://github.com/$user/$public.git" "$public" > /dev/null 2>&1; then
        echo "nop, public"
        exit 1
    fi
    cd "$public"
else
    cd "$public"
    if ! git pull > /dev/null 2>&1; then
        echo "nop, pull"
        exit 1
    fi
fi

read -p "pat: " pat

if ! git submodule set-url "$private" "https://$user:$pat@github.com/$user/$private.git" > /dev/null 2>&1; then
    echo "nop, set-url"
    exit 1
fi

if ! git submodule update --init > /dev/null 2>&1; then
    echo "nop, update"
    exit 1
fi

rm -rf "$HOME/$private"

if ! ln -s "$(pwd)/$private" "$HOME/$private" > /dev/null 2>&1; then
    echo "nop, ln"
    exit 1
fi

cd - > /dev/null 2>&1
cd "$HOME/$private" > /dev/null 2>&1

if ! sh "$init"; then
    echo "nop, init"
    exit 1
fi

cd - > /dev/null 2>&1
