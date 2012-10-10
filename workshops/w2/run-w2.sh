#!/bin/bash

# First Set
N[0]=300
N[1]=400
N[2]=500


if [ $(uname) = "Darwin" ]
then
  OS="mac"
  CC="g++-4.7"
else
  OS="linux"
  cc="g++"
fi

echo "OS $OS"s

OPTIONS="-std=c++0x -O2 -g -pg"
LIBS="-lgslcblas"
OBJ=$1
SRC="$1.cpp"

echo $OBJ
echo $SRC

INSTRUMENT_TEMPLATE="/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/Resources/templates/Time Profiler.tracetemplate"
#compile workshop
$CC $OPTIONS -o $OBJ $SRC $LIBS

#generate profile info
for i in {0..2}
do
  echo "Running ${i}th set"
  if [ $OS = "mac" ]
  then
    echo "Running on MacOS"
    FILE="results/mac/${OBJ}-${N[$i]}.log"
    echo $FILE
    instruments -t "$INSTRUMENT_TEMPLATE" -D $FILE $OBJ ${N[$i]}
  else
    echo "Running some linux distro."
    ./$OBJ ${N[$i]}
    gprof -p $OBJ > "results/linux/${N[$i]}x${NR[$i]}.log"
  fi
done

