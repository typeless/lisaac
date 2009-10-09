#! /bin/bash

self="$(cd "$(dirname "$0")"; pwd)/$(basename "$0")"
op_default=true
op_runcwd=false
op_testname="`pwd`"

while [ $# -gt 0 ]; do
  case "$1" in
    -d)
      cd "$2"
      op_testname="$2"
      op_default=false
      op_runcwd=true
      shift 2
      ;;
    *)
      shift
      break
      ;;
  esac
done

if $op_default; then
  cd "`dirname "$0"`"
  if [ -x bin/lisaac -o -x shorter ]; then
    echo "Add to PATH: `pwd`/bin"
    export PATH="`pwd`/bin:$PATH"
  fi
  if [ -x lisaac -o -x shorter ]; then
    echo "Add to PATH: `pwd`"
    export PATH="`pwd`:$PATH"
  fi
  n=0
  failed=()
  for f in tests/*; do
    if [ -d "$f" ]; then
      "$self" -d "$f"
      res=$?
      if [ $res != 0 ]; then
        failed=("${failed[@]}" $f)
      fi
      n=$(($n+$res))
    fi
  done
  echo
  if [ $n = 0 ]; then
    echo "*** SUCCESS ***"
  else
    echo "*** FAILURE ***"
    for f in "${failed[@]}"; do
      echo " - $f"
    done
    echo
  fi
  exit $n
fi

header(){
  local max="$1"
  local char="$2"
  local title="$3"
  if [ -z "$title" ]; then
    local ruler_len=$(( $max / ${#char} ))
  else
    local ruler_len=$(( ( $max - ${#title} - 2 ) / ( 2 * ${#char} ) ))
  fi
  local ruler="$(printf "%${ruler_len}s" "")"
  local ruler="${ruler// /$char}"
  if [ -z "$title" ]; then
    echo "$ruler"
  else
    if [ $(( ( max - ${#title} ) % 2 )) = 1 ]; then
      echo "$ruler $title  $ruler"
    else
      echo "$ruler $title $ruler"
    fi
  fi
}

if $op_runcwd; then
  res=1
  echo
  header 80 '*' "$op_testname"
  #echo "******************** $op_testname ********************"
  if [ -f test.sh -a -x test.sh ]; then
    ./test.sh
    res=$?
  else
    echo "Unknown test: $op_testname"
  fi
  if [ $res != 0 ]; then
    header 80 ' ' "error: $res"
  fi
  header 80 '*'
  echo
  exit $res
fi

exit 0
