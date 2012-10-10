#!/bin/bash

# First Set
N[0]=250
N[1]=500
N[2]=1000


if [ $(uname) = "Darwin" ]
then
  OS="mac"
  CC="g++-4.7"
else
  OS="linux"
  CC="g++"
fi

echo "OS $OS"

OPTIONS="-std=c++0x -O2 -g -pg"
LIBS="-lgslcblas"
LIBRARY_PATH="-L /usr/local/lib"
OBJ=$1
SRC="$1.cpp"

echo $OBJ
echo $SRC

INSTRUMENT_TEMPLATE="/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/Resources/templates/Time Profiler.tracetemplate"
#compile workshop
$CC $OPTIONS -o $OBJ $SRC $LIBRARY_PATH $LIBS

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
    FILE="results/linux/${OBJ}-${N[$i]}.log"
    gprof -p $OBJ > $FILE
  fi
done

