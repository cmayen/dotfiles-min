# dotfiles-min

A minimal dotfiles repo for a docker and devpod dev-environment with git set to use existing github ssh keys. Built on Debian GNU/Linux 12 (bookworm).

With some personal tuning done, of course. Here's the quick and dirty:

---

## Quick Start

This example is based on a new minimal ubuntu 24.04 server/workstation installation on a virtual machine. Adapt this quick start to your needs and personal workstation design.

#### SSH keys for git and github authentication.

This quick start assumes your id_ed25519 key is ready to go and in place with the correct permissions on the host workstation or VM.

```
$ ls -l ~/.ssh/id_ed25519
-rw-------  1 u u  411 Nov 11 18:02 id_ed25519
```

Note from the [GitHub docs about SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys#checking-for-existing-ssh-keys).

> By default, the filenames of supported public keys for GitHub are one of the following.
- _id_rsa.pub_  
- _id_ecdsa.pub_
- _id_ed25519.pub_

For more information about generation of a new GitHub SSH key or addition of an existing key to the ssh-agent, see [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

#### Install Updates, Docker, DevPod, and setup keys.

Install and setup what we need on the workstation.

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

#### Create and Launch a basic devpod to get things started

**Option 1**

Create a minimal devcontainer.json file to start with. This is helpful for a quick deployment of a private dotfiles repo. The generated devcontainer.json file should match the repository one, as the local file is what starts the process.

```
new_pod_name=devenv
dotfiles_repo=cmayen/dotfiles-min
mkdir $new_pod_name
mkdir $new_pod_name/.devcontainer
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

# ssh into the pod
echo "DevPod: $new_pod_name Ready"
echo "To Connect: ssh $new_pod_name.devpod"
```

**Option 2**

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

# ssh into the pod
echo "DevPod: $new_pod_name Ready"
echo "To Connect: ssh $new_pod_name.devpod"
```

#### Connect to the devcontainer

```
ssh $new_pod_name.devpod
```

#### Finish github setup

The first login will prompt for the user and email of the used id_ed25519 github key owner. If this isn't handled right away, we will have to do it later when trying to commit.

```
u@ubuntu:~$ ssh devenv.devpod
Enter your GitHub username: 
Enter your GitHub email: 
➜ /workspaces/devenv
$
```

#### Enjoy!

That's all there is to setting up this quick and dirty dotfiles-min on a fresh machine with github ssh keys.

---

## Tree

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
│   └── README.md
└── README.md
```

#### bootstrap.sh

The bootstrap.sh script is automatically ran when the devpod is created. This will:
- check for updates, apply them, and install vim
- setup a local bin path at ~/.local/bin
- patch the ~/.bashrc file with the repos stored patch file.

---

#### .devcontainer/

Contains patch files and archived originals for customizations made to the devpod container config files.



---

#### .patches/

Contains patch files and archived originals for customizations made to the devpod container config files like ~/.bashrc. [.patches/README.md] also includes diff code examples.




---


