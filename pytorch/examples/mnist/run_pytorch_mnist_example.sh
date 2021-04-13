#!/bin/bash -l
#SBATCH --mem=2G
#SBATCH --time=00:15:00

if [[ "$#" -eq 1 ]]; then
    echo "Loading module: "$1
    module load $1
    module list
fi

curl -L -o pytorch-example-mnist.py https://github.com/pytorch/examples/raw/master/mnist/main.py 

echo 'Running pytorch mnist example with buffered output'
python pytorch-example-mnist.py | sponge pytorch-example-mnist.out
