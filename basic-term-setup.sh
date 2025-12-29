#!/usr/bin/bash
set -euo pipefail
if [ -f ~/.zshrc ]; then
    export SHELL_RC_FILE="$HOME/.zshrc"
elif [ -f ~/.bashrc ]; then
    export SHELL_RC_FILE="$HOME/.bashrc"
fi

SUDO="sudo"

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
  CURRENT_SHELL=$(basename "$SHELL")
  if ! check_cmd zoxide; then
      printf "export PATH=\"\$HOME/.local/bin:\$PATH\"\n" >> $SHELL_RC_FILE
      export PATH="$HOME/.local/bin:$PATH"
      echo "added to path"
      echo $PATH
  fi
  eval "$(zoxide init $CURRENT_SHELL)"
  printf "eval \"\$(zoxide init %s)\"\n" "$CURRENT_SHELL" >> "$SHELL_RC_FILE"
else 
  printf "\033[0;32m✔\033[0m\n"
fi

printf "Checking fzf installation..."
# install fzf IF NOT INSTALLED
if ! check_cmd fzf; then
  if [ "$(uname)" = "Darwin" ]; then
    ## on mac with homebrew
      brew install fzf
      $(brew --prefix)/opt/fzf/install
  elif [ -f /etc/debian_version ]; then
    ## using apt
      try_sudo apt install -y fzf
  else 
    # print in red letters
    printf "\033[0;31mCould not install fzf. Please install it manually.\033[0m\n"
  fi
  else 
    printf "\033[0;32m✔\033[0m\n"
fi

printf "Checking vim installation..."
# install vim IF NOT INSTALLED
if ! check_cmd vim; then
  if [ "$(uname)" = "Darwin" ]; then
    ## on mac with homebrew
      brew install vim
  elif [ -f /etc/debian_version ]; then
    ## using apt
      try_sudo apt install -y vim
  else 
    # print in red letters
    printf "\033[0;31mCould not install vim. Please install it manually.\033[0m\n"
  fi
  else 
    printf "\033[0;32m✔\033[0m\n"
fi

# install wget
printf "Checking wget installation..."
if ! check_cmd wget; then
  if [ "$(uname)" = "Darwin" ]; then
    ## on mac with homebrew
      brew install wget
  elif [ -f /etc/debian_version ]; then
    ## using apt
      try_sudo apt install -y wget
  else 
    # print in red letters
    printf "\033[0;31mCould not install wget. Please install it manually.\033[0m\n"
  fi
  else 
    printf "\033[0;32m✔\033[0m\n"
fi

# install fastfetch if NOT INSTALLED
printf "Checking fastfetch installation..."
if ! check_cmd fastfetch; then
  if [ "$(uname)" = "Darwin" ]; then
    ## on mac with homebrew
      brew install fastfetch
  elif [ -f /etc/debian_version ]; then
    # Detect architecture
    ARCH=$(dpkg --print-architecture)
    
    # Get the latest release URL
    LATEST_URL=$(wget -qO- https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-$ARCH.deb" | cut -d '"' -f 4)
    
    if [ -z "$LATEST_URL" ]; then
        printf "\n\t\033[0;31mError: Could not find a release for architecture: $ARCH\033[0m\n"
        exit 1
    fi
    
    # Download and install
    printf "\n\tDownloading fastfetch..."
    wget -O /tmp/fastfetch.deb "$LATEST_URL"
    
    printf "\n\tInstalling downloaded package..."
    try_sudo apt install -y /tmp/fastfetch.deb
    
    # Cleanup
    rm -f /tmp/fastfetch.deb

    # add fastfetch to shell config files
    printf "if [[ \$- == *i* ]]; then \n  fastfetch \nfi\n" >> $SHELL_RC_FILE
  else 
    # print in red letters
    printf "\n\033[0;31mCould not install fastfetch. Please install it manually.\033[0m\n"
  fi
  else 
    printf "\033[0;32m✔\033[0m\n"
fi

# install iperf3 if NOT INSTALLED
printf "Checking iperf3 installation..."
if ! check_cmd iperf3; then
  if [ "$(uname)" = "Darwin" ]; then
    ## on mac with homebrew
      brew install iperf3
  elif [ -f /etc/debian_version ]; then
    ## using apt
      try_sudo apt install -y iperf3
  else 
    # print in red letters
    printf "\033[0;31mCould not install iperf3. Please install it manually.\033[0m\n"
  fi
  else 
    printf "\033[0;32m✔\033[0m\n"
fi

# install rsync IF NOT INSTALLED
printf "Checking rsync installation..."
if ! check_cmd rsync; then
  if [ "$(uname)" = "Darwin" ]; then
    ## on mac with homebrew
      brew install rsync
  elif [ -f /etc/debian_version ]; then
    ## using apt
      try_sudo apt install -y rsync
  else 
    # print in red letters
    printf "\033[0;31mCould not install rsync. Please install it manually.\033[0m\n"
  fi
  else 
    printf "\033[0;32m✔\033[0m\n"
fi
