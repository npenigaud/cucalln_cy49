#!/bin/bash
#SBATCH --partition gpu 
#SBATCH --mem=247000 
#SBATCH --ntasks-per-node 64
#SBATCH --gpus-per-node 4 
#SBATCH -N 1
#SBATCH --gres=gpu:1 
#SBATCH --time 04:00:00

set -x

ulimit -s unlimited
export OMP_STACKSIZE=4G
export OMP_NUM_THREADS=8
module load nvidia/24.5
SUBMIT_DIR=/perm/soa1/cucalln2_oct26_mod/cucalln.$$

mkdir $SUBMIT_DIR
cd $SUBMIT_DIR

arch=gpu_nvhpc_d
#arch=cpu_intel_d

binaire=version_any

######test bon fonctionnement - petit
#for method in openmp openmp_bitrepro openmpsinglecolumn openaccsinglecolumn
for nblocs in $(seq 50 50 6000)
do
for nreg in none 168 128 96 80 72 64
do
for method in openaccmanyblocks openaccsinglecolumn 
do
../binaires/${binaire}_${nreg}/main_cucalln_mf.x \
  --case-in /ec/res4/hpcperm/soa1/cucalln2_d   \
  --verbose  --stat  \
  --nproma 32        \
  --ngpblks $nblocs        \
  --times 50          \
  --out time_${method}_${binaire}_${nreg}.txt \
  --method $method > ${binaire}_${method}_${nreg}.txt 2>&1
done
done
done
