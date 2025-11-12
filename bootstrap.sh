#!/usr/bin/bash

set -euo pipefail

# do updates and install vim
sudo apt update && sudo apt upgrade -y && sudo apt install vim -y

# setup local bin path
mkdir -p /home/$USER/.local/bin

# patch .bashrc file from a diff generated file
#   run in "/home/$USER/dotfiles/" repository base folder
#   don't forget to checkout before doing the diff
# diff -u .patches/dot_bashrc.original ~/.bashrc > .patches/dot_bashrc.patch
patch /home/$USER/.bashrc < .patches/dot_bashrc.patch

# patch the /root/.bashrc also
sudo patch /root/.bashrc < .patches/root__dot_bashrc.patch

exit 0
