#!/bin/bash -l
#SBATCH --mem=6G
#SBATCH --time=00:15:00

set -e

if [[ "$#" -gt 0 ]]; then
    echo "Loading modules: "$MODULES
    MODULES=${@:1}
    module purge
    module load $MODULES
    module list
fi

EXAMPLE_SCRIPT=pytorch_mnist-example.py

curl -L -o $EXAMPLE_SCRIPT https://raw.githubusercontent.com/pytorch/examples/main/mnist/main.py

srun python -u $EXAMPLE_SCRIPT --epochs 5
