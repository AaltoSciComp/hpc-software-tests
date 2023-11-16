Idea to test the nvidia management library without messing with cuda code and compilation.

You may need to install e.g.:
 - cuda-nvml-devel-12-3


In addition to nvidia-driver-NVML if not using cuda modules


On a triton v3 cpu node as root:

```
dnf install git make gcc cuda-nvml-devel-12-3
git clone https://github.com/AaltoSciComp/hpc-software-tests.git
cd hpc-software-tests/nvml/  
make
./nvml_test
```

The answer is "Failed to initialize NVML: Driver Not Loaded"

Which is probably the correct answer.
