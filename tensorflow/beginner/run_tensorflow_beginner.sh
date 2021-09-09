#!/bin/bash -l
#SBATCH --mem=2G
#SBATCH --time=00:15:00

set -e

if [[ "$#" -eq 1 ]]; then
    echo "Loading module: "$1
    module load $1
    module list
fi

if [ ! -e tensorflow-tutorial-beginner.ipynb ] ; then

    echo 'Downloading tensorflow beginner tutorial notebook ...'
    curl -L -o tensorflow-tutorial-beginner.ipynb https://github.com/tensorflow/docs/raw/master/site/en/tutorials/quickstart/beginner.ipynb 

fi

if [ ! -e tensorflow-tutorial-beginner.py ] ; then

    echo 'Converting tensorflow beginner tutorial notebook to a python code file ...'
    ipython nbconvert tensorflow-tutorial-beginner.ipynb --to script --stdout > tensorflow-tutorial-beginner.py

fi

python tensorflow-tutorial-beginner.py
