#!/bin/sh

set -e

main() {
  if [ $# != 2 ]; then
    print_usage
    exit 2
  fi

  case "$1" in
  collect)
    collect_dotfiles "$2"
    ;;
  deploy)
    deploy_dotfiles "$2"
    ;;
  *)
    print_usage
    exit 2
    ;;
  esac
}

print_usage() {
  echo "Usage: 
  	$0 <collect|deploy> CONFIG

CONFIG is a list of all files (not directories) that are meanth
to be stored as dotfile configuration. Listing a path means that 
collect/deploy will manage this file.

Managing directories is not allowed, so that a sensitive files 
are not included by a mistake. Each file must be explicitly 
mentioned.

  "
}

collect_dotfiles() {
  dst=$(dirname "$(realpath "$1")")

  while read -r line; do
    # Expand any variable, so that i.e. $HOME can be used.
    src=$(eval "echo $line")

    if [ -z "$src" ]; then
      continue
    fi

    if [ ! -r "$src" ]; then
      logerr "$src does not exist or cannot be accessed"
    elif [ -f "$src" ]; then
      collect_file "$dst" "$src"
    elif [ -d "$src" ]; then
      logerr "$src is a directory. Collecting a directory is not allowed."
    else
      logerr "$src cannot be collected."
    fi
  done <"$1"
}

collect_file() {
  dst_root=$1
  src=$2
  dst_path=${src#"$HOME/"}
  mkdir -p "$dst_root/$(dirname "$dst_path")"
  cp "$src" "$dst_root/$dst_path"
  chmod +r "$dst_root/$dst_path"
}

logerr() {
  echo >&2 "ERR" "$@"
}

deploy_dotfiles() {
  src_root=$(dirname "$(realpath "$1")")

  while read -r line; do
    # Expand any variable, so that i.e. $HOME can be used.
    dst=$(eval "echo $line")

    if [ -z "$dst" ]; then
      continue
    fi

    src=${dst#"$HOME"}
    mkdir -p "$dst/$(dirname "$src")"
    ln -r "$src_root$src" "$dst"
  done <"$1"
}

main "$@"
