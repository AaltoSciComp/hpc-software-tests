# encoding: utf-8

from openbabel import pybel
mol = pybel.readstring("smi", "CC(=O)Br")
mol.make3D()
print(mol.write("sdf"))
mol.draw(show=False,filename='test.png')
