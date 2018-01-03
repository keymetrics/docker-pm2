#!/bin/bash

hash git 2>/dev/null || { echo >&2 "git not found, exiting."; }

# get the most recent commit which modified any of "$@"
function fileCommit() {
  git log -1 --format='format:%H' HEAD -- "$@"
}

tpath='tags'
url='https://github.com/keymetrics/docker-pm2'
self="$(basename "${BASH_SOURCE[0]}")"

declare -A versions paths
versions['latest']='alpine|stretch|jessie|slim|wheezy'
versions['8']='alpine|stretch|jessie|slim|wheezy'
versions['6']='alpine|stretch|jessie|slim|wheezy'
versions['4']='alpine|stretch|jessie|slim|wheezy'
paths['alpine']='alpine'
paths['stretch']='debian/stretch'
paths['jessie']='debian/jessie'
paths['slim']='debian/slim'
paths['wheezy']='debian/wheezy'

echo "# This file is generated via $url/blob/$(fileCommit "$self")/$self"
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

    commit="$(fileCommit "$tpath/$version/${paths[$variant]}")"
    echo "Tags: $version"-"$variant"
    echo "GitCommit: $commit"
    echo "Directory: $tpath/$version/${paths[$variant]}"
    echo

  done
done
