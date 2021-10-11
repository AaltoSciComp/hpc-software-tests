#!/bin/bash -l
#SBATCH --mem=4G
#SBATCH --ntasks=4
#SBATCH --time=00:05:00

set -e

if [[ "$#" -gt 0 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

[[ ! -d "${FOAM_TUTORIALS}" ]] && ( echo 'FOAM_TUTORIALS is not set' && exit 1 )

rm -rf damBreak

cp -r $FOAM_TUTORIALS/multiphase/interFoam/laminar/damBreak/damBreak damBreak

cd damBreak

blockMesh
decomposePar

srun interFoam -parallel | tee damBreak.out

grep -q "Finalising parallel run" damBreak.out
if [ $? -eq 0 ] ; then
    echo 'Successfully ran damBreak'
else
    echo 'Did not run damBreak successfully'
    exit 1
fi
    
