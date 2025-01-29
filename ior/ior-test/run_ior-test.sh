#!/bin/bash -l
#SBATCH --mem=10G
#SBATCH --ntasks-per-node=20
#SBATCH --nodes=2-2
#SBATCH --time=00:15:00

set -e

if [[ "$#" -gt 0 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

#IOR_PARAMS="-c"
#IOR_PARAMS="-t 1m -b 16m -s 16 -F"
PARAMS=("-c -a MPIIO -t 1m -b 16m -s 16 -i5" "-c -a HDF5 -t 1m -b 16m -s 16 -i5"  "-c -a POSIX -t 1m -b 16m -s 16 -i5 -F")

# The following are for two csl nodes: "--nodes=2 --tasks-per-node=20"
WRITESP=(1600 800 15000)
READSP=(1600 800 50000)
	    
if [[ $(command -v srun) ]]; then
    echo 'Launching with srun'

    
    for i in "${!PARAMS[@]}"; do
	echo running "\"srun ior ${PARAMS[$i]}\""
	output=$( srun ior ${PARAMS[$i]} )
	echo  output "$output"
	# Get the mean write spead
	W=$( echo "$output" | awk '
  /Summary of all tests:/ { summary_found = 1; next }
  summary_found && /^write/ { print $4; exit }
')
	# Get the mean read spead
	R=$( echo "$output" | awk '
  /Summary of all tests:/ { summary_found = 1; next }
  summary_found && /^read/ { print $4; exit }
')
	echo "mean write speed $W (min ${WRITESP[$i]})"
	# Check speeds
	if ! awk -v val="$W" -v ref="${WRITESP[$i]}" '
BEGIN {
    if (val > ref) {
        exit 0  # Successful comparison, num1 is greater
    } else {
        exit 1  # Unsuccessful comparison, num1 is not greater
    }
}'	; then
	    exit $?
	fi
	echo mean write speed OK
	
	echo "mean read speed $R (min ${READSP[$i]})"
	# Check speeds
	if ! awk -v val="$R" -v ref="${READSP[$i]}" '
BEGIN {
    if (val > ref) {
        exit 0  # Successful comparison, num1 is greater
    } else {
        exit 1  # Unsuccessful comparison, num1 is not greater
    }
}'	; then
	    exit $?
	fi
	echo mean read speed OK

    done
#elif [[ $(command -v mpirun) ]]; then
#    echo 'Launching with mpirun'
#    mpirun  $IOR_PARAMS | grep 'Hello world launched with 4 processors.'
#    exit $?
else
    echo 'Could not find srun/mpirun to run the example!'
    exit 1
fi

# Success
exit 0
