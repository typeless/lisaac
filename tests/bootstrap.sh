#! /bin/sh

log(){
  echo "$@"
  "$@"
}

run(){
  echo "$@"
  "$@"
  if [ $? != 0 ]; then
    echo "** Error"
  fi
}

cd "`dirname "$0"`"
cd ..

echo "** In: `pwd`"

echo "** Create bootstrap directory"
mkdir -p bootstrap
cp bin/lisaac.c bootstrap
echo "#define LISAAC_DIRECTORY \"`pwd`\"" > bootstrap/path.h
cd bootstrap

echo "** Cleaning up"
run rm -f lisaac lisaac1* lisaac2*

echo "** Compile provided lisaac.c: lisaac"
run make CFLAGS=-lm lisaac

echo "** Compile Lisaac sources:    lisaac1"
run ./lisaac  ../src/make.lip -compiler -optim -o lisaac1

echo "** Compile Lisaac sources:    lisaac2"
run ./lisaac1 ../src/make.lip -compiler -optim -o lisaac2

echo "** Test lisaac2"
run ./lisaac2 -version

exit $?
