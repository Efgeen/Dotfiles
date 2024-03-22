#!/bin/sh

user="Efgeen"
repo=".dotfiles"
init="init.sh"

if [ -e "$HOME/$repo" ]; then
    read -p "$HOME/$repo exists, rm -rf? (y/n): " rmrf
    if [ "$rmrf" = "y" ]; then
        break
    else
        echo "rmrf"
        exit 1
    fi
fi

if ! command -v git > /dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install git -y
fi

read -p "pass: " pass

if ! git ls-remote -h --exit-code -q "https://$user:$pass@github.com/$user/$repo.git" > /dev/null 2>&1; then
    echo "pass"
    exit 1
fi

rm -rf "$HOME/$repo"

if ! git clone "https://$user:$pass@github.com/$user/$repo.git" "$HOME/$repo" > /dev/null 2>&1; then
    echo "clone"
    exit 1
fi

cd "$HOME/$repo" > /dev/null 2>&1

if ! sh "$init"; then
    echo "nop, init"
    exit 1
fi

cd - > /dev/null 2>&1
