# Known to run with anaconda/2021-04-tf2

from mpi4py import MPI
import logging

logging.basicConfig(level=logging.DEBUG,format='%(asctime)s %(message)s')

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

logging.info('Hello world! rank/size [{}/{}]'.format(rank,size))




comm.Barrier()


# Tensorflow is here to offer some load to the filesystem 
logging.info("Importing tensorflow [{}]".format(rank))

import tensorflow as tf
import numpy as np
#import matplotlib.pyplot as plt
import scipy
import h5py
import plotly

logging.info("TensorFlow version '{}' [{}]".format(tf.__version__, rank))
logging.info("Loaded from {} [{}]".format(tf.__file__,rank))

comm.Barrier()

logging.info("Complete [{}]".format(rank))
