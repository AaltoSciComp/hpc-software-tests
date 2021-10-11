#!/bin/bash -l
#SBATCH --mem=6G
#SBATCH --time=00:15:00

set -e

if [[ "$#" -gt 1 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

curl -L -o pytorch-example-mnist.py https://github.com/pytorch/examples/raw/master/mnist/main.py 

echo 'Running pytorch mnist example with buffered output'
time python pytorch-example-mnist.py | sponge pytorch-example-mnist.out
