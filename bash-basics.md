# Basic Linux/Unix Commands

## Environment Variables

```bash
# List all exported variables
env

# Common exported variables:
# $HOME      # /Users/bartek
# $PWD       # Current directory
# $USER      # Username
# $PATH      # Command search paths

# List ALL variables (exported + shell-only)
set

# Shell-specific variables:
# $OSTYPE    # darwin24 (OS type)
# $OLDPWD    # Previous directory
```

## List Files <ls = LiSt>

```bash
# -l = long format (detailed info)
# -a = all files (including hidden dotfiles)
ls -la ~/path

# Useful for checking symlink paths:
# lrwxr-xr-x ... .zshrc -> /path/to/dotfiles/zsh/.zshrc
```

## Move Files <mv = MoVe>

```bash
# Syntax: mv [source] [destination]
mv ~/file.txt ~/Documents/file.txt

# Also used for renaming:
mv old-name.txt new-name.txt
```

## Create Links <ln = LiNk>

```bash
# -s = symbolic link (recommended for dotfiles)
# -f = force (overwrite if exists)
# Syntax: ln -sf [source/real-file] [destination/link-location]
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
```

## Change Permissions <chmod = CHange MODe>

```bash
# +x = add execute permission (make file runnable)
chmod +x script.sh

# -x = remove execute permission
chmod -x script.sh

# Common permissions:
# chmod 755 file  # rwxr-xr-x (owner: all, others: read+execute)
# chmod 644 file  # rw-r--r-- (owner: read+write, others: read-only)
```

## Bash Conditionals

```bash
# If statement structure
if [[ condition ]]; then
    # Commands when true
else
    # Commands when false
fi

# Example - detect OS:
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS detected"
else
    echo "Linux detected"
fi

# Note: Must have spaces around [[ ]] and use == for string comparison
```
