source ${HOME}/.local/share/sh/homebrew.sh
homebrew_dir=$(homebrew_location)

typeset -U path
path=(~/bin ~/.local/bin /opt/homebrew/opt/python@3.9/libexec/bin "${homebrew_dir}/opt/ruby/bin" "${homebrew_dir}/lib/ruby/gems/3.0.0/bin" "$path[@]" /usr/local/sbin /usr/local/bin)

export EDITOR="$(which nvim)"

export GOSS_PATH=~/bin/goss-linux-amd64
export GPG_TTY=$(tty)

export COMPOSE_DOCKER_CLI_BUILD=1
export GLAMOUR_STYLE=dark
