#!/bin/bash -l
#SBATCH --mem=4G
#SBATCH --time=00:15:00

if [[ "$#" -eq 1 ]]; then
    echo "Loading module: "$1
    module load $1
    module list
fi

export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK:-1}"

echo "Running with "$OMP_NUM_THREADS" threads"

srun python -u blas-benchmark.py
