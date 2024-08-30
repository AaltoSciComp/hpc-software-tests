#!/bin/bash

set -euo pipefail

if [[ $# -lt 3 ]]; then
    cat << EOF
    usage:

        $0 MPICC MPICXX MODULE [ MODULE ... ]

EOF
    exit 1
fi

SCRIPTDIR=`readlink -f $(dirname $0)`

MPICC=$1
MPICXX=$2
MPI_NAME=$3

NSLASHES=$(echo $MPI_NAME | tr -cd '/' | wc -c)

if [ $NSLASHES -ne 1 ] ; then
    echo 'MPI name "'$MPI_NAME'" is not in format "mpi-flavor/mpi-version"'
    exit 1
fi

echo 'Loading MPI module '$MPI_NAME

module --ignore_cache load $MPI_NAME
module list

BUILDDIR=$SCRIPTDIR/build/$MPI_NAME
INSTALLDIR=$SCRIPTDIR/bin/$MPI_NAME
BENCHMARK=osu-micro-benchmarks-7.3

if [ ! -f "${BENCHMARK}.tar.gz" ]; then
    wget http://mvapich.cse.ohio-state.edu/download/mvapich/${BENCHMARK}.tar.gz
fi

echo 'Building '$BENCHMARK' in '$BUILDDIR
echo 'Installing '$BENCHMARK' to '$INSTALLDIR

mkdir -p ${BUILDDIR}
mkdir -p ${INSTALLDIR}
cp ${BENCHMARK}.tar.gz ${BUILDDIR}
cd ${BUILDDIR}
tar xvzf ${BENCHMARK}.tar.gz
cd ${BENCHMARK}
./configure CC=${MPICC} CXX=${MPICXX} --prefix=${INSTALLDIR}
make -j 2
make install
