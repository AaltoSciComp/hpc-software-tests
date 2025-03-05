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

nITERS=5

#IOR_PARAMS="-c"
#IOR_PARAMS="-t 1m -b 16m -s 16 -F"
PARAMS=("-c -a MPIIO -t 1m -b 16m -s 16 -i $nITERS" "-c -a HDF5 -t 1m -b 16m -s 16 -i $nITERS"  "-c -a POSIX -t 1m -b 16m -s 16 -i $nITERS -F")

echo "running on $HOSTNAME ($SLURM_JOB_NODELIST)"

HOST_SHORT=$( hostname -s )
HOSTNAME_STRIPPED=${HOST_SHORT//[0-9]/}

case "$HOSTNAME_STRIPPED" in
  *milan*)
    WRITESP=(1200 550 14000)
    READSP=(1500 400 100000)
    ;;
  *csl*)
    # The following are for two csl nodes: "--nodes=2 --tasks-per-node=20"
    WRITESP=(1600 800 15000)
    READSP=(1600 800 50000)
    ;;
  *skl*)
    # The following are for two skl nodes: "--nodes=2 --tasks-per-node=20"
    WRITESP=(1400 700 15000)
    READSP=(1400 600 45000)
    ;;
  *pe*)
    WRITESP=(100 100 100)
    READSP=(100 100 100)
    ;;
  *)
      echo No speed requirement given
      exit 2
    ;;
esac

	    
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
	    echo FAIL exit
	    exit 2
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
	    echo FAIL exit
	    exit 2
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
