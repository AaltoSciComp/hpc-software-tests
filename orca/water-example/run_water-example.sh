#!/bin/bash
#SBATCH --mem=2G
#SBATCH --ntasks-per-node=4
#SBATCH --nodes=1
#SBATCH --time=00:15:00

set -e

if [[ "$#" -gt 0 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

rm -f water*

cat > water.inp << EOF
!HF DEF2-SVP PAL4
* xyz 0 1
O   0.0000   0.0000   0.0626
H  -0.7920   0.0000  -0.4973
H   0.7920   0.0000  -0.4973
*
EOF

$(command -v orca) water.inp > water.out
