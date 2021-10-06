#!/bin/bash -l
#SBATCH --time=00:05:00

set -e

if [[ "$#" -eq 1 ]]; then
    echo "Running on: "$(hostname)
    echo "Loading module: "$1
    module purge
    module load $1
fi

rm -f test.png

srun python3 pybel-example.py

if [[ -f test.png ]]; then
    echo 'Openbabel example ran successfully!'
else
    echo 'No test.png found. Running openbabel example failed!'
    exit 1
fi
