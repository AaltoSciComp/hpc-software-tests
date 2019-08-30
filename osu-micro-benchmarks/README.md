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

Outputs will be written to `output/<mpi-module>/<mpi-version>.out`.

## Known issues

- For OpenMPI 3.1.4 the one-sided latency test will hang. It can be skipped by removing it with `rm bin/openmpi/3.1.4/libexec/osu-micro-benchmarks/mpi/one-sided/osu_acc_latency`
