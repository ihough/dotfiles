# dotfiles

My dotfiles for [Spirit](https://documentations.ipsl.fr/MESO_User/spirit_clusters/head_nodes.html)

## Installation

### Using git and the bootstrap script

Clone this repository, switch to the `spirit` branch, and run `bootstrap.sh`:

```bash
git clone --branch spirit https://github.com/ihough/dotfiles.git
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
curl -#L https://github.com/ihough/dotfiles/tarball/spirit | tar -xzv --strip-components 1 --exclude={bootstrap.sh,LICENSE-MIT.txt,README.md}
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

## Updates

To copy changes from your local dotfiles (in `$HOME`) to this repository, run `get-local-changes.sh`:

```bash
source get-local-changes.sh
```

Then examine and commit the desired changes.
