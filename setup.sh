#!/bin/sh

force=false
username="Efgeen"
repository=".dotfiles"
destination="$HOME/.dotfiles"

for arg in "$@"; do
    if [ "$arg" = "-f" ]; then
        force=true
        break
    fi
done

if [ -d "$destination" ] && [ "$force" = false ]; then
    echo "nop, exists"
    exit 1
fi

read -p "pat: " pat

if ! command -v git > /dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install git -y
fi

if ! git ls-remote -h --exit-code -q "https://$username:$pat@github.com/$username/$repository.git" > /dev/null 2>&1; then
    echo "nop, auth"
    exit 1
fi

mkdir -p "$destination"

if ! git clone "https://$username:$pat@github.com/$username/$repository.git" "$destination" > /dev/null 2>&1; then
    echo "nop, clone"
    exit 1
fi

cd "$destination"

if ! sh "init.sh"; then
    echo "nop, init"
    exit 1
fi

cd - > /dev/null 2>&1
