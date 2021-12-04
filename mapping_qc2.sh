#!/bin/bash
#SBATCH --job-name=mapping_qc2
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=00:30:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
module load samtools
source activate nanopore

IN_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/mapped_reads
bam_files=$(find $IN_DIR -name '*bam')

for file in $bam_files

do 
	barcode=$(basename $file)
	echo $barcode
	
	#use samtools stats to get the number of mapped reads 
	mapped_number=$(samtools stats $file | grep "reads mapped:" | awk '{print $4}')
	echo $mapped_number
	echo $barcode $'\t' $mapped_number >> ${IN_DIR}/mapping_stats.tsv 

done
