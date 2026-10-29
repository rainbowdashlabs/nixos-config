usage() {
  cat >&2 <<EOF
Usage: git place clone <url>   clone into the dev tree, asking work/private and a category
       git place move          move the current repository to another category

Work:    $work_root/[category/]<repo>
Private: $private_root/<owner>/[category/]<repo>

The final path is printed on stdout, everything else goes to stderr.
EOF
}

dev_root=${GIT_PLACE_ROOT:-$HOME/dev}
work_root=$dev_root/work
private_root=$dev_root/private

die() {
  echo "git place: $*" >&2
  exit 1
}

pick() {
  local prompt=$1
  shift
  printf '%s\n' "$@" | fzf --height=~15 --layout=reverse --prompt="$prompt> "
}

parse_url() {
  local path=$1
  path=${path%/}
  path=${path%.git}
  case $path in
    *://*) path=${path#*://}; path=${path#*/} ;;
    *@*:*) path=${path#*:} ;;
    *@*/*) path=${path#*/} ;;
    *) die "not a git url: $1" ;;
  esac
  repo=${path##*/}
  owner=${path%/*}
  [ -n "$repo" ] && [ "$owner" != "$path" ] || die "cannot read owner and repository from: $1"
  owner=${owner##*/}
}

categories() {
  local base=$1
  local repo_path
  [ -d "$base" ] || return 0
  find "$base" -mindepth 1 -maxdepth 4 \
    \( -name '.*' -prune \) -o \
    \( -type d -exec test -e '{}/.git' \; -printf '%P\n' -prune \) |
    while IFS= read -r repo_path; do
      while [ "$repo_path" != "${repo_path%/*}" ]; do
        repo_path=${repo_path%/*}
        printf '%s\n' "$repo_path"
      done
    done | sort -u
}

choose_kind() {
  pick "work or private" private work || die "aborted"
}

choose_category() {
  local base=$1 out status query choice
  local -a existing
  mapfile -t existing < <(categories "$base")
  status=0
  out=$(printf '%s\n' "(none)" "${existing[@]}" |
    fzf --height=~15 --layout=reverse --print-query \
      --prompt="category> " --header="pick one, or type a new name") || status=$?
  [ "$status" -le 1 ] || die "aborted"
  query=$(sed -n 1p <<<"$out")
  choice=$(sed -n 2p <<<"$out")
  if [ -z "$choice" ]; then
    choice=$query
  fi
  [ "$choice" = "(none)" ] && choice=
  choice=${choice#/}
  choice=${choice%/}
  case "/$choice/" in
    */../* | */./*) die "invalid category: $choice" ;;
  esac
  printf '%s' "$choice"
}

base_for() {
  local kind=$1
  if [ "$kind" = work ]; then
    printf '%s' "$work_root"
  else
    printf '%s/%s' "$private_root" "$owner"
  fi
}

target_in() {
  local base=$1 category=$2
  if [ -n "$category" ]; then
    printf '%s/%s/%s' "$base" "$category" "$repo"
  else
    printf '%s/%s' "$base" "$repo"
  fi
}

cmd_clone() {
  [ $# -eq 1 ] || { usage; exit 1; }
  local url=$1 kind base category target
  parse_url "$url"
  kind=$(choose_kind)
  base=$(base_for "$kind")
  category=$(choose_category "$base")
  target=$(target_in "$base" "$category")
  [ -e "$target" ] && die "already exists: $target"
  mkdir -p "$(dirname "$target")"
  if ! git clone "$url" "$target" >&2; then
    rmdir -p --ignore-fail-on-non-empty "$(dirname "$target")" 2>/dev/null || true
    exit 1
  fi
  printf '%s\n' "$target"
}

cmd_move() {
  [ $# -eq 0 ] || { usage; exit 1; }
  local current base category target
  current=$(git rev-parse --show-toplevel 2>/dev/null) || die "not inside a git repository"
  repo=${current##*/}
  case $current/ in
    "$work_root"/*) base=$work_root ;;
    "$private_root"/*/*)
      owner=${current#"$private_root"/}
      owner=${owner%%/*}
      base=$private_root/$owner
      ;;
    *) die "$current is not under $work_root or $private_root" ;;
  esac
  category=$(choose_category "$base")
  target=$(target_in "$base" "$category")
  [ "$target" = "$current" ] && { printf '%s\n' "$target"; return; }
  [ -e "$target" ] && die "already exists: $target"
  mkdir -p "$(dirname "$target")"
  mv "$current" "$target"
  rmdir -p --ignore-fail-on-non-empty "$(dirname "$current")" 2>/dev/null || true
  echo "moved $current -> $target" >&2
  printf '%s\n' "$target"
}

case ${1:-} in
  clone) shift; cmd_clone "$@" ;;
  move) shift; cmd_move "$@" ;;
  *) usage; exit 1 ;;
esac
