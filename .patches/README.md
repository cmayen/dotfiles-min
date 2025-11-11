# .patches
Modifications to the base image files.

---



#### .patches/dot_bashrc.original
The original ~/.bashrc file when the dotfiles-min repo was developed.

---

#### .patches/dot_bashrc.patch
A patch file generated to update the devpods ~/.bashrc file

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



