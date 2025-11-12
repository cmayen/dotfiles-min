# dotfiles-min

A minimal dotfiles repo for a docker and devpod dev-environment with git preconfigured to use existing github ssh keys. Built on Debian GNU/Linux 12 (bookworm).

With some personal tuning done, of course. Here's the quick and dirty:

![CLI Example](https://raw.githubusercontent.com/cmayen/cmayen/refs/heads/main/dotfiles-min-cli-2511121042.webp)

- Customized prompt with git branch shown.
- Removed display of current local username.
- Moved user prompt `$` symbol to a new line.
- Ensured root user is displayed and changed root prompt to `#` symbol.
- git preconfigured with github ssh key stored on parent workstation path.
- Ensures `git config` values are available on first login.
- Local dotfiles repository clone in `~/dotfiles/`


Minimal with basic quality of life tweaks. Godo to use for a starting point for more advanced environments and interesting devpod experiments.

---

## Quick Start

This example is based on a new minimal ubuntu 24.04 server/workstation installation on a virtual machine. Commands should be ran as the normal user and can be executed in the user home directory `~/` or any directory of your choosing like `~/devcontainers/`. Adapt this quick start to your needs and personal workstation design.

### SSH keys for git and github authentication.

This quick start assumes your id_ed25519 key is ready to go and in place with the correct permissions on the host workstation or VM.

```
$ ls -l ~/.ssh/id_ed25519
-rw-------  1 u u  411 Nov 11 18:02 id_ed25519
```

Note from the [GitHub docs about SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys#checking-for-existing-ssh-keys).

> By default, the filenames of supported public keys for GitHub are one of the following.
> - _id_rsa.pub_  
> - _id_ecdsa.pub_
> - _id_ed25519.pub_
>
> For more information about generation of a new GitHub SSH key or addition of an existing key to the ssh-agent, see [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

### Setup keys, install updates, Docker, and DevPod.

The key should be already in place at `~/.ssh/id_ed25519` on the workstation. Install and setup what we need on this example ubuntu workstation.

```
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io -y
sudo usermod -aG docker $USER

# add agent startup to .bashrc
cat >> ~/.bashrc << 'EOF'
# start agent if not already running
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" >/dev/null
    # add the github key
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi
EOF

# download and install devpod
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod

# set devpod up to use docker as it's provider
devpod provider add docker

# restart the terminal/session to fast track logout/login
# required to update group memberships
# This will prompt for the user password
echo ""
echo "Re-Login as $USER:"
exec su -l $USER
```

### Create and Launch a basic devpod to get things started



- **Option 1**

Download the devcontainer.json from the public repo and place it locally for initialization. 

```
new_pod_name=devenv
dotfiles_repo=cmayen/dotfiles-min

mkdir $new_pod_name
mkdir $new_pod_name/.devcontainer

# use curl to pull the devcontainer.json from a public repo
curl https://raw.githubusercontent.com/$dotfiles_repo/refs/heads/main/.devcontainer/devcontainer.json > $new_pod_name/.devcontainer/devcontainer.json

# spin up the devpod in the folder
devpod up $new_pod_name --ide none --dotfiles git@github.com:$dotfiles_repo

# inform the user the devpod is ready and example ssh command
echo "DevPod: $new_pod_name Ready"
echo "To Connect: ssh $new_pod_name.devpod"
```

- **Option 2**

If using a private github repository, or just need a fresh unmodified image, `cat` can be used to dynamically generate a devcontainer.json file. The generated devcontainer.json file should match the private repository one, as the local file is what starts the process.

```
new_pod_name=devenv
dotfiles_repo=cmayen/dotfiles-min

mkdir $new_pod_name
mkdir $new_pod_name/.devcontainer

# use cat to dynamically generate the devcontainer.json file
cat > $new_pod_name/.devcontainer/devcontainer.json << EOF
{
  "name": "$new_pod_name",
  "image": "mcr.microsoft.com/devcontainers/base:debian-12",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}
  }
}
EOF

# spin up the devpod in the folder
devpod up $new_pod_name --ide none --dotfiles git@github.com:$dotfiles_repo

# output complete and example command to connect
echo "DevPod: $new_pod_name is Ready"
echo "To Connect: ssh $new_pod_name.devpod"
```

### Connect to the devcontainer

```
ssh $new_pod_name.devpod
```

### Finish github setup

The first login will prompt for the user and email of the id_ed25519 github key owner if it is not automatically detected or setup from the workstation. If this isn't handled right away, we will have to setup git config later when actively trying to commit a change.

```
user@ubuntu:~$ ssh devenv.devpod
git config --global user.name: username
git config --global user.email: email@example.com

➜ /workspaces/devenv
$
```

### Enjoy!

That's the basics for setting up this quick and dirty dotfiles-min environment on a fresh workstation with git and github ssh connection.

But there's one more thing...

### Managing Running Containers

When logged out of the devpod containers and working on the workstation cli, view the active containers with the devpod commands.

```
devpod list
```

```
  NAME  |                SOURCE              | PROVIDER | LAST USED |  AGE
---------------------------------------------------------------------------
 devenv | local:/home/u/devcontainers/devenv | docker   | 31m59s    | 33m1s

```

There is 1 running here. The dotfiles-min example devpod `devenv`. 

#### Removing old/unused active devpods

- Stopping and removing with devpod

```
devpod delete devenv
```

Clean easy cleanup.


---
---

## dotfiles-min repo Project Tree

```
.
├── bootstrap.sh
├── .devcontainer
│   ├── devcontainer.json
│   └── README.md
├── LICENSE
├── .patches
│   ├── dot_bashrc.original
│   ├── dot_bashrc.patch
│   ├── root__dot_bashrc.original
│   ├── root__dot_bashrc.patch
│   └── README.md
└── README.md
```

### bootstrap.sh

The bootstrap.sh script is automatically ran when the devpod is created and the github repository syncs for the first time. This will:
- check for updates, apply them, and install vim
- setup a local bin path at `~/.local/bin` for future use.
- patch the .bashrc files with the repos stored patches.

---

### [.devcontainer/](.devcontainer/) 

DevPod devcontainer.json container config files.

---

### [.patches/](.patches/)

Patch files and archived originals for customizations made to the devpod container files like `~/.bashrc`. 

