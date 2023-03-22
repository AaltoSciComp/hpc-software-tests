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

if [[ $(command -v srun) ]]; then
    echo 'Launching with srun'
    srun interFoam -parallel | tee damBreak.out
elif [[ $(command -v mpirun) ]]; then
    echo 'Launching with mpirun'
    mpirun -np 4 interFoam -parallel | tee damBreak.out
else
    echo 'Could not find srun/mpirun to run the example!'
    exit 1
fi

grep -q "Finalising parallel run" damBreak.out
if [ $? -eq 0 ] ; then
    echo 'Successfully ran damBreak'
else
    echo 'Did not run damBreak successfully'
    exit 1
fi
