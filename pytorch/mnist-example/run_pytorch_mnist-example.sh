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

# Fixed version without .accelerator
EXAMPLE_URL="https://raw.githubusercontent.com/pytorch/examples/47d0c2eff22201df7742c2de3fe5723dd6cebe0d/mnist/main.py"

# Latest
#EXAMPLE_URL="https://raw.githubusercontent.com/pytorch/examples/main/mnist/main.py"

curl -L -o $EXAMPLE_SCRIPT $EXAMPLE_URL

python -u $EXAMPLE_SCRIPT --epochs 5
