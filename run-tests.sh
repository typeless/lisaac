#! /bin/bash

self="$(cd "$(dirname "$0")"; pwd)/$(basename "$0")"
op_default=true
op_runcwd=false
op_testname="`pwd`"
op_importance=0
op_importance_max=-1
op_report=

while [ $# -gt 0 ]; do
  case "$1" in
    -d)
      cd "$2"
      op_testname="$2"
      op_default=false
      op_runcwd=true
      shift 2
      ;;
    -i)
      op_importance="$2"
      shift 2
      ;;
    -I)
      op_importance_max="$2"
      shift 2
      ;;
    -r)
      op_report="$2"
      shift 2
      ;;
    -h|-help|--help)
      echo "NAME"
      echo "  run-tests.sh - automatically run tests for the Lisaac compiler"
      echo
      echo "SYNOPSIS"
      echo "  run-tests.sh [OPTIONS]"
      echo
      echo "OPTIONS"
      echo
      echo "  -h, -help, --help"
      echo "      Show this help"
      echo
      echo "  -i IMPORTANCE"
      echo "      Run only tests that have an importance greater or equal to"
      echo "      IMPORTANCE"
      echo
      echo "  -I IMPORTANCE"
      echo "      Run only tests that have an importance less than IMPORTANCE"
      echo
      echo "  -r REPORT"
      echo "      write report REPORT"
      echo
      echo "  -d DIR"
      echo "      Run test in DIR"
      exit 0
      ;;
    *)
      shift
      break
      ;;
  esac
done

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

test-patterns(){
  while read pattern; do
    [ -z "$pattern" ] && continue
    if ! egrep -- "$pattern" <<<"$2" >/dev/null; then
      echo " - Expected:    $pattern"
      echo
      echo "$2"
      return 1
    else
      echo " - Match:       $pattern"
    fi
  done <<<"$1"
  return 0
}

run_test(){
  local oldcwd="`pwd`"
  local res
  local testpath="$1"
  if [ -n "$testpath" ]; then
    cd "$testpath"
  fi
  local imp
  if [ -f make.lip ]; then
    imp="`lisaac -test-importance 2>&1`"
  elif [ -f importance ]; then
    imp="`cat importance`"
  else
    imp=0
  fi
  if [ "0$imp" -lt "0$op_importance" ] || ( \
     [ 0 -le "$op_importance_max" ] && [ "0$imp" -ge "0$op_importance_max" ] )
  then
    cd "$oldcwd"
    return 255
  fi
  res=1
  echo
  header 80 '*' "$(basename "`pwd`") ($imp)"
  if [ -f test.sh -a -x test.sh ]; then
    ./test.sh
    res=$?
  elif [ -f make.lip ]; then
    lisaac -test-description 2>&1
    args=(-test)
    if ! lisaac -test-run 2>&1; then
      args=("${args[@]}" -partial)
      partial=true
    else
      partial=false
    fi
    compile="$(lisaac "${args[@]}" -o result.exe 2>&1)"
    res=$?
    echo
    if [ $res != 0 ]; then
      echo " - Compilation: $res"
    else
      echo " - Compilation: ok"
    fi
    if ! lisaac -test-compile; then
      res=0
    fi
    if [ $res != 0 ]; then
      echo
      echo "$compile"
    else
      compile_patterns="$(lisaac -test-compile-patterns 2>&1)"
      test-patterns "$compile_patterns" "$compile"
      res=$?
      if ! $partial && [ $res = 0 ]; then
        run="$(./result.exe)"
        res=$?
        if [ $res != 0 ]; then
          echo " - Execution:   $res"
        else
          echo " - Execution:   ok"
        fi
        run_patterns="$(lisaac -test-run-patterns 2>&1)"
        test-patterns "$run_patterns" "$run"
        res2=$?
        if [ $res = 0 ]; then
          res=$res2
        fi
        if [ $res2 = 0 ]; then
          echo
          echo "$run"
        fi
      elif [ $res = 0 ]; then
        echo
        echo "$compile"
      fi
    fi
    if [ $res = 0 ]; then
      local test_execute=$(lisaac -test-execute)
      if [ -n "$test_execute" ]; then
        echo $test_execute
        $test_execute
        echo
        if [ $res != 0 ]; then
          echo " - Execution:   $res"
        else
          echo " - Execution:   ok"
        fi
      fi
    fi
  else
    echo "Unknown test: $testpath"
  fi
  if [ $res != 0 ]; then
    header 80 ' ' "error: $res"
  else
    header 80 ' ' "ok"
  fi
  header 80 '*'
  echo
  cd "$oldcwd"
  return $res
}

echo  $op_runcwd
echo  $op_default

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
  ignored=()
  success=()
  failed=()
  expected_failed=()
	echo ici
  for f in tests/*; do
    if [ -d "$f" ]; then
      run_test "$f"
      res=$?
      if [ $res = 255 ]; then
        ignored=("${ignored[@]}" $f)
      elif [ $res = 0 ]; then
        success=("${success[@]}" $f)
      elif [ -f "$f/fail" ]; then
        expected_failed=("${expected_failed[@]}" $f)
      else
        failed=("${failed[@]}" $f)
        n=$(($n+$res))
      fi
    fi
  done
  echo
  echo "Summary:"
  echo
  for f in "${success[@]}"; do
    echo " - SUCCESS: $f"
  done
  [ "${#success}" -gt 0 ] && echo
  for f in "${expected_failed[@]}"; do
    echo " - FAILURE EXPECTED: $f"
  done
  [ "${#expected_failed}" -gt 0 ] && echo
  for f in "${ignored[@]}"; do
    echo " - IGNORED: $f"
  done
  [ "${#ignored}" -gt 0 ] && echo
  for f in "${failed[@]}"; do
    echo " - FAILURE: $f"
  done
  [ "${#failed}" -gt 0 ] && echo
  if [ $n = 0 ]; then
    echo "*** SUCCESS ***"
  else
    echo "*** FAILURE ***"
  fi
  echo
  if [ -n "$op_report" ]; then
    (
    for f in "${success[@]}"; do
      echo "SUCCESS:$f"
    done
    for f in "${expected_failed[@]}"; do
      echo "FAILURE_EXPECTED:$f"
    done
    for f in "${ignored[@]}"; do
      echo "IGNORED:$f"
    done
    for f in "${failed[@]}"; do
      echo "FAILURE:$f"
    done
    ) > "$op_report"
  fi
  exit $n
fi

if $op_runcwd; then
  run_test
fi

exit 0
