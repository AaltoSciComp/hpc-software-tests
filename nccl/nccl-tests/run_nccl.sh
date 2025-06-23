#!/bin/bash


#SBATCH --nodes=1                                                          
#SBATCH --ntasks-per-node=1                                                     
#SBATCH --time=0-00:15:00                                                       
#SBATCH --cpus-per-task=128                                                     
#SBATCH --partition=gpu-h200-141g-ellis                                         
#SBATCH --mem=1932G                                                             
#SBATCH --gpus-per-task=8  


if [[ "$#" -gt 0 ]]; then
    echo "Loading modules: "$MODULES
    MODULES=${@:1}
    module purge
    module load $MODULES
    module list
else
    module load triton/2025.1-gcc nccl/2.22.3-1 cuda/12.6.2 openmpi/5.0.3 gcc/13.3.0
fi

pushd .
if [[ ! -d "nccl-tests" ]]; then
    git clone https://github.com/NVIDIA/nccl-tests
fi
    
cd nccl-tests
make MPI=1 NCCL_HOME=$NCCL_ROOT CUDA_HOME=$CUDA_ROOT MPI_HOME=$OPENMPI_ROOT 

./build/all_reduce_perf -b 8 -e 128M -f 2 -g 8

popd
#rm -r nccl-tests/
