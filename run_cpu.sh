#!/bin/bash
#SBATCH -N1
#SBATCH -p ndl
#SBATCH --time 00:10:00
#SBATCH --gres=gpu:4
#SBATCH --exclusive
#SBATCH --switches=3

set -x

ulimit -s unlimited
export OMP_STACKSIZE=4G
export OMP_NUM_THREADS=8

SUBMIT_DIR=./cucalln.$$
mkdir $SUBMIT_DIR
cd $SUBMIT_DIR

module load nvidia/24.5

arch=gpu_nvhpc_d
#arch=cpu_intel_d
#export NV_ACC_DEBUG=1
######test bon fonctionnement - petit
#for method in openmp openmp_bitrepro openmpsinglecolumn openaccsinglecolumn
for method in openmpsinglecolumn manyblocks 
do
../compile.${arch}/main_cucalln_mf.x \
  --case-in /ec/res4/hpcperm/soa1/cucalln2_d \
  --verbose  --stat  \
  --nproma 32        \
  --ngpblks 100        \
  --times 1          \
  --method $method > $method.txt 2>&1
done

