#!/bin/bash
cd ~/.dotfiles

stow -t ~ common

case "$(uname)" in
  Darwin) stow -t ~ darwin ;;
  Linux)  stow -t ~ linux ;;
esac
