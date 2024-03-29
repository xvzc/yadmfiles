#!/bin/sh

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

echo "Detected OS: ${machine}"

if [ "$machine" == "Mac" ]; then
    if type brew > /dev/null 2>&1; then
        echo "Found brew at $(whareis brew). Skipping install."
    else
        echo "homdbrew not found. installing.."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" && \
	eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "Installing MacOS packages.."
    brew bundle --file=~/yadmfile/Brewfile
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   echo "Installing Linux packages.."
else
   echo "Cannot determine operation system."
   exit 1;
fi

