#!/bin/bash -l
#SBATCH --mem=2G
#SBATCH --time=00:15:00

if [[ "$#" -eq 1 ]]; then
    echo "Loading module: "$1
    module load $1
    module list
fi

curl -L -o tensorflow-tutorial-beginner.ipynb https://github.com/tensorflow/docs/raw/master/site/en/tutorials/quickstart/beginner.ipynb 

ipython nbconvert tensorflow-tutorial-beginner.ipynb --to script --stdout > tensorflow-tutorial-beginner.py

python tensorflow-tutorial-beginner.py
