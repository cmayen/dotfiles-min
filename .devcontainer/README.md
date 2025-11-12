# .devcontainer
The base image of the dotfiles repo

---

image: mcr.microsoft.com/devcontainers/base:debian-12


features:
- ghcr.io/devcontainers/features/github-cli:1







---
---

##### 🕶 "Copy" this "dotfiles-min" repository to your own private one

- Create a new empty private repository on github.
- Create a devpod based on the Quick Start example pulling from the public repo cmayen/dotfiles-min

Inside the dotfiles-min devpod:

- Copy the files to the workspace and remove the current .git information.
- Change to the directory
- Initialize git
- Set git to the main branch, add the files, commit and push

```
new_dotfiles_repouser=cmayen
new_dotfiles_reponame=dotfiles-new

cp -R ~/dotfiles /workspaces/devenv/$new_dotfiles_reponame
rm -rf /workspaces/devenv/$new_dotfiles_reponame/.git
cd /workspaces/devenv/$new_dotfiles_reponame
git init
git branch -M main
git add .
git commit -m "first commit: duplicated repo from cmayen/dotfiles-min"
git remote add origin git@github.com:$new_dotfiles_repouser/$new_dotfiles_reponame.git
git push -u origin main
```

- Now spin up the new devpod using a modified private repo example from the quick start targetting dotfiles-new.

And buy me a coffee or somethin'! ☕️ lol
