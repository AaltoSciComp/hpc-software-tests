#include <stdio.h>
#include <nvml.h>

int main() {
  nvmlReturn_t result;
  unsigned int device_count, i;
  nvmlDevice_t device;
  char name[NVML_DEVICE_NAME_BUFFER_SIZE];
  nvmlMemory_t memory;
  nvmlUtilization_t utilization;

  // Initialize NVML                                                                                                                                                                                                   
  result = nvmlInit();
  if (result != NVML_SUCCESS) {
    printf("Failed to initialize NVML: %s\n", nvmlErrorString(result));
    return 1;
  }

  // Get the number of available GPUs                                                                                                                                                                                  
  result = nvmlDeviceGetCount(&device_count);
  if (result != NVML_SUCCESS) {
    printf("Failed to get device count: %s\n", nvmlErrorString(result));
    nvmlShutdown();
    return 1;
  }

  printf("Found %u GPU(s) on this system\n", device_count);

  // Iterate through each GPU                                                                                                                                                                                          
  for (i = 0; i < device_count; i++) {
    result = nvmlDeviceGetHandleByIndex(i, &device);
    if (result != NVML_SUCCESS) {
      printf("Failed to get handle for GPU %u: %s\n", i, nvmlErrorString(result));
      continue;
    }

    // Get GPU name                                                                                                                                                                                                  
    result = nvmlDeviceGetName(device, name, NVML_DEVICE_NAME_BUFFER_SIZE);
    if (result != NVML_SUCCESS) {
      printf("Failed to get name of GPU %u: %s\n", i, nvmlErrorString(result));
      continue;
    }

    printf("GPU %u: %s\n", i, name);

    // Get GPU memory information                                                                                                                                                                                    
    result = nvmlDeviceGetMemoryInfo(device, &memory);
    if (result != NVML_SUCCESS) {
      printf("Failed to get memory info for GPU %u: %s\n", i, nvmlErrorString(result));
      continue;
    }

    printf("Memory Total: %llu bytes, Free: %llu bytes\n", memory.total, memory.free);

    // Get GPU utilization                                                                                                                                                                                           
    result = nvmlDeviceGetUtilizationRates(device, &utilization);
    if (result != NVML_SUCCESS) {
      printf("Failed to get utilization for GPU %u: %s\n", i, nvmlErrorString(result));
      continue;
    }

    printf("GPU Utilization: %u%%\n", utilization.gpu);
  }

  // Shutdown NVML                                                                                                                                                                                                     
  nvmlShutdown();

  return 0;
}
