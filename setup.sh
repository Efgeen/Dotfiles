#!/bin/sh

user="Efgeen"
dir="$HOME/.dotfiles"
repo=".dotfiles"
init="init.sh"

if [ -e "$dir" ]; then
    read -p "$dir exists, rm -rf? (y/n): " rmrf
    if [ "$rmrf" = "y" ]; then
        break
    else
        echo "nop"
        exit 1
    fi
fi

if ! command -v git > /dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install git -y
fi

read -p "pass: " pass

if ! git ls-remote -h --exit-code -q "https://$user:$pass@github.com/$user/$repo.git" > /dev/null 2>&1; then
    echo "pass fail"
    exit 1
fi

rm -rf "$dir"

if ! git clone "https://$user:$pass@github.com/$user/$repo.git" "$dir" > /dev/null 2>&1; then
    echo "clone fail"
    exit 1
fi

cd "$dir" > /dev/null 2>&1

if ! sh "$init"; then
    echo "init fail"
    exit 1
fi

cd - > /dev/null 2>&1
