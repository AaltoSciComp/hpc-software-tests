#!/bin/bash -l
#SBATCH --mem-per-cpu=2G
#SBATCH --ntasks-per-node=16
#SBATCH --nodes=2
#SBATCH --time=01:00:00

set -e

if [[ "$#" -gt 0 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

export QE_VERSION=${QE_VERSION:=qe-6.8}

if [[ ! -d ${QE_VERSION} ]] ; then
    git clone --depth 1 --branch ${QE_VERSION} https://gitlab.com/QEF/q-e.git ${QE_VERSION}
fi

export MAIN_FOLDER="${PWD}"
export PSEUDO_FOLDER="${PWD}/pseudo"

mkdir -p $PSEUDO_FOLDER

cp ${QE_VERSION}/pseudo/* $PSEUDO_FOLDER

cd ${QE_VERSION}/test-suite

sed -i "s:\(TESTCODE_NPROCS=\).*:\1${SLURM_NTASKS}:g" ENVIRONMENT
sed -i "s:\(ESPRESSO_ROOT=\).*:\1${QUANTUM_ESPRESSO_ROOT}:g" ENVIRONMENT
sed -i "s:\(ESPRESSO_PSEUDO=\).*:\1${PSEUDO_FOLDER}:g" ENVIRONMENT
sed -i "s|\(NETWORK_PSEUDO=\).*|\1https://pseudopotentials.quantum-espresso.org/upf_files/|g" ENVIRONMENT
sed -i "s:\(TESTCODE_DIR=\).*:\1${PWD}/testcode:g" ENVIRONMENT
sed -i "s:\$(ESPRESSO_ROOT):$(realpath ${PWD}/..):g" Makefile
sed -i "s:\(PARA_PREFIX=\).*:\1\"srun\":g" *.sh

make pseudo
make run-tests-parallel
