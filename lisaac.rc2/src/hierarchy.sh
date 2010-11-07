#!/bin/bash

cd "`dirname "$0"`"

op_markdown=false

while true; do
  case "$1" in
    -h)
      echo "`basename "$0"` -h"
      echo "`basename "$0"` [OPTIONS ...] [TYPE ...]"
      echo
      echo "Print type hierarchy starting from the types given or the root of the"
      echo "hierarchy tree detected by the script. The resulting output is"
      echo "compatible with the markdown syntax."
      echo
      echo "-m      Markdown Syntax"
      echo
      exit 0
      ;;
    -m)
      op_markdown=true
      ;;
    *)
      break;
  esac
  shift
done

inheritance="$(find . -name "*.li" | \
  xargs grep '[+-] parent_' | \
  sed -r 's/^.*\/([^\/]*)\.li:.*[^A-Z0-9_]([A-Z][A-Z0-9_]*)[^A-Z0-9_].*$/\1 \2/' | \
  tr a-z A-Z)"

#echo "$inheritance"

roots=$(echo $@ | tr a-z A-Z)

if [ -z "$roots" ]; then

  all_types="$(find . -name "*.li" | \
    xargs -n 1 basename | \
    cut -d. -f1 | \
    tr a-z A-Z | \
    sort | uniq)"

  roots="$all_types"

  while read line; do
    foo=($line)
    child="${foo[0]}"
    parent="${foo[1]}"
    if grep "^$parent$" <<<"$all_types" >/dev/null; then
      #echo "Remove $child from roots because its parent $parent exists"
      roots="$(grep -v "^$child$" <<<"$roots")"
    fi
  done <<<"$inheritance"

fi

parse(){
  local parent=$1
  local indent="$2"
  local dir
  dir=$(find . -name "`tr A-Z a-z <<<"${parent}"`.li" | xargs -n 1 dirname | cut -d/ -f2-)
  if [ . = "$dir" ] || [ -z "$dir" ]; then
    if $op_markdown; then
      echo "$indent- \`$parent\`"
    else
      echo "$indent- $parent"
    fi
  else
    if $op_markdown; then
      echo "$indent- \`$parent\` (\`$dir\`)"
    else
      echo "$indent- $parent ($dir)"
    fi
  fi
  indent="$indent    "
  local children=$(echo "$inheritance" | grep " $parent$" | cut -d" " -f1)
  if [ -n "$children" ]; then
    for child in $children; do
      parse $child "$indent"
    done
    echo
  fi
}

for root in $roots; do
  parse $root
done