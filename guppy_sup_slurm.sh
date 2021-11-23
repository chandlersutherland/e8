#!/bin/bash
#SBATCH --job-name=sac_20211109_S3
#SBATCH --account=fc_kvkallow
#SBATCH --partition=savio3_gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:GTX2080TI:1
#SBATCH --time=24:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL

#this script would allow for super accurate basecalling on the cluster using GPUs. However, only savio3_gpu has the appropriate video cards for nanopore basecalling and I only have access to gpu calling through fc_kvkallow
nano_dir=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b

cd /global/home/users/chandlersutherland/programs/ont-guppy/bin
./guppy_basecaller -i ${nano_dir}/fast5_pass/ \
-s ${nano_dir}/sup_guppy/ \
-c dna_r9.4.1_450bps_sup.cfg \
-x cuda:0
