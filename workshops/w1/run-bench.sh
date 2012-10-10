#!/bin/bash

# First Set
N[0]=80
NR[0]=50

N[1]=160
NR[1]=50

N[2]=320
NR[2]=50


# Second Set
N[3]=80
NR[3]=100

N[4]=160
NR[4]=100

N[5]=320
NR[5]=100


# Third Set
N[6]=80
NR[6]=200

N[7]=160
NR[7]=200

N[8]=320
NR[8]=200


# Fourth Set
N[9]=80
NR[9]=400

N[10]=160
NR[10]=400

N[11]=320
NR[11]=400


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
OBJ="w1"
SRC="w1.cpp"

INSTRUMENT_TEMPLATE="/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/Resources/templates/Time Profiler.tracetemplate"
#compile workshop
$CC $OPTIONS -o $OBJ $SRC

#generate profile info
for i in {0..11}
do
  echo "Running ${i}th set"
  if [ $OS = "mac" ]
  then
    echo "Running on MacOS"
    instruments -t "$INSTRUMENT_TEMPLATE" -D results/mac/"${N[$i]}x${NR[$i]}.log" $OBJ ${N[$i]} ${NR[$i]}
  else
    echo "Running some linux distro."
    ./$OBJ ${N[$i]} ${NR[$i]}
    gprof -p $OBJ > "results/linux/${N[$i]}x${NR[$i]}.log"
  fi
done

