# Test that regular jax works

print("Testing normal JAX functionality:")

from jax import grad
import jax.numpy as jnp

def tanh(x):  # Define a function
  y = jnp.exp(-2.0 * x)
  return (1.0 - y) / (1.0 + y)

grad_tanh = grad(tanh)  # Obtain its gradient function
#print(grad_tanh(1.0))   # Evaluate it at x = 1.0
# prints 0.4199743

# Verify that result is correct

assert abs(grad_tanh(1.0) - 0.4199743) < 1e-6

print(True)

# Test that JIT compilation works

print("Testing jit compilation:")

import jax.numpy as jnp
from jax import jit

def slow_f(x):
  # Element-wise ops see a large benefit from fusion
  return x * x + x * 2.0

x = jnp.ones((5000, 5000))
fast_f = jit(slow_f)

#print(slow_f(x).sum())
#print(fast_f(x).sum())

assert slow_f(x).sum() == fast_f(x).sum()

# Test that JAX is using GPU
print(True)

print("Testing that JAX used GPUs:")

device = jnp.ones(3).device_buffer.device()

#print(device)

assert str(device) == "gpu:0"

print(True)

# Test SPMD

print("Testing SPMD on multiple GPUs")

from jax import random, pmap

# Get the number of GPU devices
import os

ngpus = len(os.environ.get("CUDA_VISIBLE_DEVICES", "0").split(","))

# Create ngpus random 5000 x 6000 matrices, one per GPU
keys = random.split(random.PRNGKey(0), ngpus)
mats = pmap(lambda key: random.normal(key, (5000, 6000)))(keys)

# Run a local matmul on each device in parallel (no data transfer)
result = pmap(lambda x: jnp.dot(x, x.T))(mats)  # result.shape is (8, 5000, 5000)

# Compute the mean on each device in parallel and print the result
means = pmap(jnp.mean)(result)
#print(means)
# prints [1.1566595 1.1805978 ... 1.2321935 1.2015157]
assert len(means) == ngpus
print(True)
