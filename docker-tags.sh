#!/bin/bash

hash git 2>/dev/null || { echo >&2 "git not found, exiting."; }

# get the most recent commit which modified any of "$@"
function fileCommit() {
  git log -1 --format='format:%H' HEAD -- "$@"
}

tpath='tags'
url='https://github.com/keymetrics/docker-pm2'
self="$(basename "${BASH_SOURCE[0]}")"
date=$(date +'%Y-%m-%d %H:%M:%S')

declare -A versions
versions['latest']='alpine|bookworm|bullseye|buster|slim'
versions['24']='alpine|bookworm|bullseye|buster|slim'
versions['22']='alpine|bookworm|bullseye|buster|slim'
versions['20']='alpine|bookworm|bullseye|buster|slim'
versions['18']='alpine|bookworm|bullseye|buster|slim'

echo "# This file is generated via $url/blob/$(fileCommit "$self")/$self"
echo "# $date"
echo
echo "Maintainers: Keymetrics.io <$url> (@keymetrics)"
echo "GitRepo: $url.git"
echo

for version in "${!versions[@]}"
do

  variants=(${versions[$version]//|/ })
  for i in "${!variants[@]}"
  do
    variant=${variants[i]}

    commit="$(fileCommit "$tpath/$version/$variant")"
    echo "Tags: $version"-"$variant"
    echo "GitCommit: $commit"
    echo "Directory: $tpath/$version/$variant"
    echo

  done
done
