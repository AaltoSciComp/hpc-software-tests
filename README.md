# hpc-software-tests

This repo contains various tests for software installed in Aalto's HPC cluster.

## Test suite

There is a test suite built around `pytest` in `hpc_tests`.

Main configurations for running the tests are:

- `hpc_tests/aalto.yaml` - Tests for Triton production software
- `hpc_tests/aalto_dev.yaml` - Tests for Triton development software
- `hpc_tests/aalto-desktop.yaml` - Tests for Aalto desktop software
- `hpc_tests/aalto-desktop_dev.yaml` - Tests for Aalto desktop development software

To run the tests, you can use the `run_tests.sh`-wrapper. This will launch tests
through the queue system.

Example ways of using the script:

- To run all tests, run `bash run_tests.sh`
- To run development tests, run `bash run_tests.sh -d`
- To check available tests, run `bash run_tests.sh -l`
- To run one individual test, run `bash run_tests.sh -k openfoam_dambreak-example-openfoam_2306`

## Tests

Tests are divided into their own folders. The structure is `APPLICATION_NAME/TEST_NAME`.

Most tests have a `run_TEST_NAME.sh`-script that can be called with the following syntax:

```
sbatch run_TEST_NAME.sh MODULE_NAME/MODULE_VERSION MODULE_NAME/MODULE_VERSION
```

Each test should return an exit code of `0` if test was successful and some other if not.

Some folders have its own README-file that describes how the code is supposed to be run.

Tests available in test suite:

- `blas/simple-c` - Compiles and tests BLAS examples written in C. Used for testing OpenBLAS/MKL installations.
- `c/hello-world` - Compiles a simple hello world written in C. Used to test compilers.
- `fortran/hello-world` - Compiles a simple hello world written in Fortran. Used to test compilers.
- `gurobi/c-examples` - Compiles Gurobi examples written in C. Tests Gurobi headers and libraries.
- `gurobi/introduction-to-modeling` - Run an example for Gurobi's Python tutorial. Tests Gurobi's Python module.
- `jax/example` - Runs a simple jax example with JIT compiling and GPU usage.
- `mpi/hello-world` - Runs a simple hello world using MPI. Tests MPI's integration with Slurm.
- `mpi4py/barrier` - Runs a simple mpi4py tests. Tests mpi4py.
- `ncl/evans-plot` - Runs one example from ncl's examples. Tests ncl.
- `numpy/blas-benchmark` - Runs a suite of BLAS benchmarks with numpy. Tests that numpy is linked to optimized BLAS library in a Python environment.
- `openbabel/pybel-example` - Run a pybel example. Tests openbabel installation.
- `openfoam/dambreak-example` - Runs an example from OpenFOAMs examples. Tests OpenFOAM.
- `orca/water-example` - Runs an example from ORCAs examples. Tests ORCA.
- `pytorch/mnist-example` - Runs a small training with PyTorch using GPUs. Tests that PyTorch can use GPUs.
- `slurm/hostname`- Runs a simple slurm script. Tests that the queue works.
- `suite-sparse/cholmod` - Compiles a cholmod example from SuiteSparse. Tests SuiteSparse.
- `tensorflow/beginner`- Runs a simple model from Tensorflow using GPU. Tests that Tensorflow can use GPUs.

Special tests with different syntax:

- `nvml` - Tests nvml.
- `mpi/osu-micro-benchmarks` - This folder contains MPI benchmarks provided by MVAPICH developers. Tests MPI communication across fabrics.
