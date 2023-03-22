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

rm -f test.png

python pybel-example.py

if [[ -f test.png ]]; then
    echo 'Openbabel example ran successfully!'
else
    echo 'No test.png found. Running openbabel example failed!'
    exit 1
fi
