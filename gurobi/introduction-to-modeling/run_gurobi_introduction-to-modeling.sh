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

EXAMPLE_NOTEBOOK=gurobi_introduction-to-modeling.ipynb
EXAMPLE_SCRIPT=${EXAMPLE_NOTEBOOK/.ipynb/.py}

if [ ! -e $EXAMPLE_NOTEBOOK ] ; then
    echo 'Downloading Gurobi Introduction to modeling-notebook ...'
    curl -L -o $EXAMPLE_NOTEBOOK https://raw.githubusercontent.com/Gurobi/modeling-examples/master/intro_to_modeling/introduction_to_modeling.ipynb
fi

if [ ! -e $EXAMPLE_SCRIPT ] ; then
    echo 'Converting Gurobi Introduction to modeling-notebook to a python script ...'
    ipython nbconvert $EXAMPLE_NOTEBOOK --to script --stdout > $EXAMPLE_SCRIPT
fi


python -u $EXAMPLE_SCRIPT
