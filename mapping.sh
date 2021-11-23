#!/bin/bash
#SBATCH --job-name=mapping_nanopore
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=24:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
module load samtools
#source activate nanopore

IN_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/fastq_pass/

for dir in $IN_DIR
do 
	cd $dir
	./global/home/users/chandlersutherland/programs/minimap2-2.22_x64-linux/minimap2 -a /global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.mmi\
	${IN_DIR}/${dir}/merged_file.fastq.gz | \
	samtools sort -o ${IN_DIR}/${dir}/reads.sorted.bam 
	samtools index ${IN_DIR}/${dir}/reads.sorted.bam
done