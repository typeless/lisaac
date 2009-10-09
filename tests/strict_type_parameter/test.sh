#! /bin/sh


echo "Test if a Strict parameter type gives you the dynamic type"

expected="dynamic_type = STRING_CONSTANT"

compile="$(lisaac dynamic_type -q -o out.exe 2>&1)" || {
  echo
  echo "$compile"
  exit 1
}

out="$(./out.exe)"
grep -q "$expected" <<<"$out" || \
{
  echo
  echo "Expected: $expected"
  echo "Got:      $out"
  exit 1
}

exit $?
