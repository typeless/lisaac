#! /bin/sh


echo "Test ( + b:BOOLEAN; b == TRUE) compiles"

compile="$(lisaac boolean_test3 -partial 2>&1)" || {
  echo
  echo "$compile"
  exit 1
}

exit 0
