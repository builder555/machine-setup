# NEW TERMINAL SETUP run: . /basic-term-setup.sh
set -e
if [ -f ~/.zshrc ]; then
    export SHELL_RC_FILE="$HOME/.zshrc"
elif [ -f ~/.bashrc ]; then
    export SHELL_RC_FILE="$HOME/.bashrc"
fi

check_cmd() {
    command -v -- "$1" >/dev/null 2>&1
}

need_sudo() {
    if ! check_cmd "${SUDO}"; then
        err "\
could not find the command \`${SUDO}\` needed to get permissions for install.

If you are on Windows, please run your shell as an administrator, then rerun this script.
Otherwise, please run this script as root, or install \`sudo\`."
    fi

    if ! "${SUDO}" -v; then
        err "sudo permissions not granted, aborting installation"
    fi
}

try_sudo() {
    if "$@" >/dev/null 2>&1; then
        return 0
    fi

    need_sudo
    "${SUDO}" "$@"
}
# on mac install brew
if [ "$(uname)" = "Darwin" ]; then
  # install homebrew IF NOT INSTALLED
  which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install zoxide IF NOT INSTALLED
printf "Checking zoxide installation..."
if ! check_cmd zoxide; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  if ! check_cmd zoxide; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> $SHELL_RC_FILE
      export PATH="$HOME/.local/bin:$PATH"
  fi
  echo 'eval "$(zoxide init '$(basename $SHELL)')"' >> $SHELL_RC_FILE
  eval "$(zoxide init $(basename $SHELL))"
else 
  # print checkmark
  printf "\033[0;32m✔\033[0m\n"
fi  
