#!/bin/bash

#SBATCH --nodes=16
#SBATCH --tasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=0:05:00

#conda create -n tf2 tensorflow mpi4py plotly


echo Using nodes: $SLURM_NODELIST

source $WRKDIR/miniconda3/etc/profile.d/conda.sh

conda activate tf2

mpirun python barrier.py

