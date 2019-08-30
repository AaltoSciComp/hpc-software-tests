# osu-micro-benchmarks

These benchmarks are available from [MVAPICH webpage](http://mvapich.cse.ohio-state.edu/benchmarks).

## Building benchmarks

```sh
module purge
./compile_osu-micro-benchmarks.sh <mpi-module>/<mpi-version>
```

Build stage will be in the `build/<mpi-module>/<mpi-version>`-folder,
binaries will be in `bin/<mpi-module>/<mpi-version>`-folder.

## Running benchmarks

```sh
module purge
sbatch run_osu-micro-benchmarks.slrm <mpi-module>/<mpi-version>
```

Outputs will be written in `output/<mpi-module>/<mpi-version>`-folder.
