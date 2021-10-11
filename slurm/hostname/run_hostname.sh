#!/bin/bash -l
#SBATCH --mem=1G
#SBATCH --time=00:05:00

set -e

if [[ "$#" -gt 0 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

srun hostname
