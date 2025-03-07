#!/bin/bash
#SBATCH -t 00:30:00
#SBATCH -N 2-2
#SBATCH -n 2
#SBATCH --mem-per-cpu=2G

set -euo pipefail

if [[ $# -lt 1 ]]; then
    cat << EOF
    usage:

        sbatch $(basename $0) mpi-flavor/mpi-version MODULE

EOF
    exit 1
fi

SCRIPTDIR=`pwd`

MPI_NAME=$1

NSLASHES=$(echo $MPI_NAME | tr -cd '/' | wc -c)

if [ $NSLASHES -ne 1 ] ; then
    echo 'MPI name "'$MPI_NAME'" is not in format "mpi-flavor/mpi-version"'
    exit 1
fi

echo 'Loading MPI module '$MPI_NAME

module --ignore_cache load $MPI_NAME
module list

INSTALLDIR=$SCRIPTDIR/bin/$MPI_NAME
if [ ! -d $INSTALLDIR ]; then
    echo 'No installation directory in '$INSTALLDIR
    exit 1
fi
OUTPUT=$SCRIPTDIR/output/${MPI_NAME}.out

mkdir -p $(dirname $OUTPUT)

echo 'Running benchmarks from: '$INSTALLDIR | tee $OUTPUT
echo 'mpicc used for compiling: '$(which mpicc) | tee -a $OUTPUT
echo 'Writing output to: '$OUTPUT | tee -a $OUTPUT

cd ${INSTALLDIR}

run_test() {
    CURRENT_FOLDER=$(pwd)
    TEST_FILE=$(readlink -f $1)
    TEST_FOLDER=$(dirname $TEST_FILE)
    TEST_NAME=$(basename $TEST_FILE)
    cd $TEST_FOLDER

    case $TEST_NAME in

        osu_cas_latency | osu_fop_latency)
            EXTRA_ARGS="-T mpi_int"
            ;;

        *)
            EXTRA_ARGS=""
            ;;
    esac
    echo "Running test $TEST_NAME (extra args: $EXTRA_ARGS):"

    srun $TEST_NAME $EXTRA_ARGS
    cd $CURRENT_FOLDER
}

export -f run_test

find ${INSTALLDIR} -type f | xargs -n 1 -I {} bash -c 'run_test "$@"' _ {} | tee -a $OUTPUT
