#!/usr/bin/env bash

#   Installs my tmux setup: the scripts onto PATH, then this directory's configuration file
#   into the home directory. Running it again is meant to be harmless, so that installing is
#   also how an update to any of these files gets applied.

source $HOME/.config/shell-utilities.sh

for f in "${PATHSCRIPTS[@]}"; do
    linkToPath "$f"
done

linkIntoHome .tmux.conf
