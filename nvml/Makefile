CC=gcc

CUDA_INCLUDE_FOLDER=/usr/local/cuda-12.3/targets/x86_64-linux/include/
CUDA_LIB_FOLDER=/share/apps/spack/envs/fgci-centos7-haswell/software/cuda/12.0.0/32o5w4t/lib64/stubs

nvml_test: nvml_test.c
	$(CC) -o $@ $^  -lnvidia-ml -I$(CUDA_INCLUDE_FOLDER) -L$(CUDA_LIB_FOLDER) -Wl,-rpath,$(CUDA_LIB_FOLDER)
