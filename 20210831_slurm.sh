#!/bin/bash
#SBATCH --job-name=20210831_fastq_pass
#SBATCH --account=fc_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=24:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL


module load samtools/1.8

/global/home/users/chandlersutherland/minimap2-2.22_x64-linux/minimap2 -a /global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.mmi /global/scratch/users/chandlersutherland/20210831_fastq_pass/*.* |\
samtools view -b - |\
samtools sort - |\
samtools index - > /global/home/users/chandlersutherland/slurm_stdout/20210831.bam
