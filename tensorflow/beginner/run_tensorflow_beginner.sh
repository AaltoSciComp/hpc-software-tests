#!/bin/bash -l
#SBATCH --mem=2G
#SBATCH --time=00:15:00

set -e

if [[ "$#" -gt 0 ]]; then
    echo "Loading modules: "$MODULES
    MODULES=${@:1}
    module purge
    module load $MODULES
    module list
fi

EXAMPLE_NOTEBOOK=tensorflow-tutorial-beginner.ipynb
EXAMPLE_SCRIPT=${EXAMPLE_NOTEBOOK/.ipynb/.py}

if [ ! -e $EXAMPLE_NOTEBOOK ] ; then
    echo 'Downloading tensorflow beginner tutorial notebook ...'
    curl -L -o $EXAMPLE_NOTEBOOK https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/quickstart/beginner.ipynb
fi

if [ ! -e $EXAMPLE_SCRIPT ] ; then
    echo 'Converting tensorflow beginner tutorial notebook to a python code file ...'
    ipython nbconvert $EXAMPLE_NOTEBOOK --to script --stdout > $EXAMPLE_SCRIPT
fi

srun python -u $EXAMPLE_SCRIPT
