#!/bin/bash -l
#SBATCH --mem=1G
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=1
#SBATCH --time=00:05:00

set -e

if [[ "$#" -gt 0 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

for DATAFILE in gcm_co2_pre.nc ndvi_time.nc pr_mme_change_sresa2.nc
do
    [[ ! -f "$DATAFILE" ]] && curl -s -o $DATAFILE https://www.ncl.ucar.edu/Applications/Data/cdf/$DATAFILE
done

[[ ! -f evans_plot.ncl ]] && curl -s -o evans_plot.ncl https://www.ncl.ucar.edu/Applications/Scripts/evans_plot.ncl 

for SCRIPT_INDEX in {1..5}
do

    NCL_SCRIPT=evans_${SCRIPT_INDEX}.ncl

    [[ ! -f "$NCL_SCRIPT" ]] && curl -s -o $NCL_SCRIPT https://www.ncl.ucar.edu/Applications/Scripts/$NCL_SCRIPT

    srun ncl $NCL_SCRIPT
    EXIT_CODE=$?

    if [[ $EXIT_CODE -ne 0 ]]
    then
        echo "Plotting failed with script $SCRIPT_INDEX"
        exit 1
    fi
done
