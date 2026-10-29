/**
  `git place`: clones into ~/dev/work or ~/dev/private/<owner>, sorted into categories, and moves
  repositories between categories. `git clone <url>` with nothing else is routed through it in zsh,
  and the shell follows into the new directory. Anything else reaches git untouched, and
  `command git clone` always does.
*/
{ pkgs, ... }:

{
  home.packages = [ (import ../../../packages/git-place { inherit pkgs; }) ];

  programs.zsh.initContent = ''
    git() {
      if { [[ $1 == clone && $# -eq 2 && $2 != -* ]] || [[ $1 == place && ( $2 == clone || $2 == move ) ]] } && [[ -t 0 ]]; then
        local dir
        if [[ $1 == clone ]]; then
          dir=$(command git-place clone "$2") || return
        else
          dir=$(command git-place "''${@:2}") || return
        fi
        cd "$dir"
      else
        command git "$@"
      fi
    }
  '';
}
