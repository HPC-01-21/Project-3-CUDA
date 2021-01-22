#!/bin/bash
# 02614 - High-Performance Computing, January 2018
# 
# batch script to run collect on a decidated server in the hpcintro
# queue
#
# Author: Bernd Dammann <bd@cc.dtu.dk>
#
#BSUB -J collectorgpu3
#BSUB -o compare3.out
#BSUB -q hpcintrogpu
#BSUB -R "rusage[mem=2048]"
#BSUB -W 30
#BSUB -n 2
#BSUB -gpu "num=2:mode=exclusive_process"

for ((c=25; c<=1000; c=c+25))
do
    echo $c
    echo "gpu3"
    jacobi_gpu3 $c 100 0 0
done 
