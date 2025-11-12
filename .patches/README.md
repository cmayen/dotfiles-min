# .patches
Modifications to the base image files for your dotfiles repo.

---

## To generate a new dot_bashrc.patch

- checkout a new branch in the ~/dotfiles/ repo
- inspect current ~/.bashrc and ensure it is ready

#### run the diff
```
diff -u ~/dotfiles/.patches/dot_bashrc.original \
  ~/.bashrc > ~/dotfiles/.patches/dot_bashrc.patch.new
```

#### Inspect first, then overwrite
```
mv ~/dotfiles/.patches/dot_bashrc.patch.new ~/dotfiles/.patches/dot_bashrc.patch
```

- add and commit, create pull request, merge, etc

---

## To generate a new root__dot_bashrc.patch

- checkout a new branch in the ~/dotfiles/ repo
- inspect current /root/.bashrc and ensure it is ready

#### Login as root

```
sudo su -
```

#### run the diff, set ownership and exit back to normal user

```
diff -u /home/vscode/dotfiles/.patches/root__dot_bashrc.original \
  /root/.bashrc > /home/vscode/dotfiles/.patches/root__dot_bashrc.patch
chown vscode:vscode /home/vscode/dotfiles/.patches/root__dot_bashrc.patch
exit
```

- add and commit, create pull request, merge, etc

---

#### Why modify the /root/.bashrc ?

There are some issues with both the vscode user and the root user on the microsoft base:debian-12 image being used. 

- Specifically new line wrapping in the CLI. adding `export LANG="en_US.UTF-8"` to both .bashrc files fixes that issue.
- The root user prompt by default uses `$` and I prefer to see `#` so the /root/.bashrc is patched for the prompt.


