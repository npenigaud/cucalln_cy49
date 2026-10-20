#!/bin/bash

if [ ! -d ../binaires ]; then
  mkdir ../binaires
fi

cp Makefile.inc.reg Makefile.inc
for nreg in 168 128 96 80 72 64
do
  make clean
  rm -rf boot fxtran-acdc
  export nreg_makefile_cucalln=$nreg
  make CFLAGS="-DFXTRAN_ACDC_VENDOR=FXTRAN_ACDC_NVIDIA -DFXTRAN_ACDC_PRAGMA=FXTRAN_ACDC_OPENACC" boot
  make
  if [ ! -d ../binaires/version_any_${nreg} ]; then
    mkdir ../binaires/version_any_${nreg}
  fi
  cp main_cucalln_mf.x ../binaires/version_any_${nreg}
done

cp Makefile.inc.none Makefile.inc
make clean
rm -rf boot fxtran-acdc
make CFLAGS="-DFXTRAN_ACDC_VENDOR=FXTRAN_ACDC_NVIDIA -DFXTRAN_ACDC_PRAGMA=FXTRAN_ACDC_OPENACC" boot
make
if [ ! -d ../binaires/version_any_none ]; then
  mkdir ../binaires/version_any_none
fi
cp main_cucalln_mf.x ../binaires/version_any_none

