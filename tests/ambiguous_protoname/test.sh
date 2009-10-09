#! /bin/sh


echo "Test if the error message contains non ambiguous prototype names"

expected="Slot \`toto' not found in \`AMBIGUOUS_PROTONAME.PROTO'."

out="$(lisaac 2>&1)"
grep -q "$expected" <<<"$out" || \
{
  echo
  echo "Expected: "
  echo "$expected"
  echo
  echo "$out"
  exit 1
}

exit $?
