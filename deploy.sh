#!/usr/bin/env bash
# Build, then publish public/ as a commit on the pages branch, which gitbay serves at
# audit-labs.dev. Run from an up-to-date main.
set -euo pipefail
cd "$(dirname "$0")"

./build.sh
src=$(git rev-parse --short HEAD)

git fetch -q origin pages
tree=$(mktemp -d)
trap 'git worktree remove --force "$tree"; git worktree prune' EXIT
git worktree add -q --detach "$tree" origin/pages

rsync -a --delete --exclude .git public/ "$tree/"
git -C "$tree" add -A
if git -C "$tree" diff --cached --quiet; then
  echo "deploy.sh: pages already matches $src"
  exit 0
fi
git -C "$tree" commit -q -m "Build $src"
git -C "$tree" push -q origin HEAD:refs/heads/pages
echo "deploy.sh: published $src to pages"
