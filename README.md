# dotfiles

My dotfiles for [CIMENT](https://gricad-doc.univ-grenoble-alpes.fr/hpc/)

## Installation

### Using git and the bootstrap script

Clone this repository, switch to the `ciment` branch, and run `bootstrap.sh`:

```bash
git clone --branch ciment https://github.com/ihough/dotfiles.git
cd dotfiles
source bootstrap.sh
```

To update, `cd` to the `dotfiles` repository and re-run `bootstrap.sh`:

```bash
source bootstrap.sh
```

### Git-free install

To install without git:

```bash
cd
curl -#L https://github.com/ihough/dotfiles/tarball/ciment | tar -xzv --strip-components 1 --exclude={bootstrap.sh,LICENSE-MIT.txt,README.md}
```

To update, just run that command again.

### Customization

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands or to add commands you don't want to commit to a public repository.

If `~/.gitconfig.user` exists, it will be included in `.gitconfig`. You can use this to set your git author name and email:

```bash
[user]
  name = Your Name
  email = your.email@domain.com
```
