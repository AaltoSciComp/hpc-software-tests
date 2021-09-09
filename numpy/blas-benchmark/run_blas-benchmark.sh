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

time1=$(date +%s)
srun python -u blas-benchmark.py
time2=$(date +%s)

time_taken=$(($time2 - $time1))

echo 'Test took '$time_taken' seconds'

if [[ $time_taken -gt 60 ]]; then
    echo 'Test took more than 60 seconds. Marking as failed!'
    exit 1
fi
