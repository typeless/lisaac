#!/bin/bash

lisaac=$1
args=
shift
if [ -z "$lisaac" ]; then
  lisaac=lisaac
  args="-O -q"
fi

#for i in `find -name "*.li"` ; do cat $i | grep -q "main" && echo Compile $i && lisaac $i -O -q ; done

find -name "*.li" | xargs grep -- '- main *<-' | cut -d: -f1 | while read li; do

  echo "$lisaac $li $@ $args"
  "$lisaac" "$li" "$@" $args
  res=$?
  [ $res != 0 ] && echo "Error $res"

done
