# osu-micro-benchmarks

These benchmarks are available from [MVAPICH webpage](http://mvapich.cse.ohio-state.edu/benchmarks).

## Building benchmarks

```sh
module purge
CC=mpicc CXX=mpicxx ./compile_osu-micro-benchmarks.sh <mpi-module>/<mpi-version>
```

When compiling with intel compilers:

```sh
CC=mpiicc CPP='mpiicc -E' CXX=mpiicpc CXXCPP='mpiicpc -E' ./compile_osu-micro-benchmarks.sh intel-parallel-studio/<intel parallel studio version>
```

Build stage will be in the `build/<mpi-module>/<mpi-version>`-folder,
binaries will be in `bin/<mpi-module>/<mpi-version>`-folder.

## Running benchmarks

```sh
module purge
sbatch run_osu-micro-benchmarks.slrm <mpi-module>/<mpi-version>
```

Outputs will be written to `output/<mpi-module>/<mpi-version>.out`.

## Known issues

- For OpenMPI 3.1.4 the one-sided latency test will hang. It can be skipped by removing it with `rm -r bin/openmpi/3.1.4/libexec/osu-micro-benchmarks/mpi/one-sided/`
- For OpenMPI 3.1.4 with UCX the following tests will hang: `osu_acc_latency`,`osu_fop_latency`, `osu_get_acc_latency` and `osu_latency_mt`. They can be skipped by removing them with `rm bin/openmpi/3.1.4/libexec/osu-micro-benchmarks/mpi/one-sided/{osu_acc_latency,osu_fop_latency,osu_get_acc_latency} bin/openmpi/*/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency_mt`
- UCX does not support atomic operations for 8 and 16 bit datatypes. This causes errors in tests `osu_latency_mt` and `osu_cas_latency`. For more info, see [this issue](https://github.com/open-mpi/ompi/issues/6777). These datatypes have been disabled for these tests.
- For OpenMPI 4.1.6 multithreaded latency test will hang. This can be removed with `find bin/openmpi/4.1.6 -name 'osu_latency_mt' -delete`
