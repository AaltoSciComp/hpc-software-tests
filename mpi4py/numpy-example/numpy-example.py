from mpi4py import MPI
import numpy

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = MPI.COMM_WORLD.Get_size()

# passing MPI datatypes explicitly
if rank == 0:
    data = numpy.arange(1000, dtype='i')
    comm.Send([data, MPI.INT], dest=1, tag=77)
elif rank < size - 1:
    data = numpy.empty(1000, dtype='i')
    comm.Recv([data, MPI.INT], source=rank-1, tag=77)
    comm.Send([data, MPI.INT], dest=rank+1, tag=77)
else:
    data = numpy.empty(1000, dtype='i')
    comm.Recv([data, MPI.INT], source=rank-1, tag=77)
    print(f"transfer 1: rank: {rank} data sum: {data.sum()}")

# automatic MPI datatype discovery
if rank == 0:
    data = numpy.arange(1000, dtype=numpy.float64)
    comm.Send(data, dest=1, tag=13)
elif rank < size - 1:
    data = numpy.empty(1000, dtype=numpy.float64)
    comm.Recv(data, source=rank-1, tag=13)
    comm.Send(data, dest=rank+1, tag=13)
else:
    data = numpy.empty(1000, dtype=numpy.float64)
    comm.Recv(data, source=rank-1, tag=13)
    print(f"transfer 2: rank: {rank} data sum: {data.sum()}")

