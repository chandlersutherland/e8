#!/bin/bash
#SBATCH --job-name=mapping_qc
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

IN_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/fastq_pass
OUT_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/mapped_reads
echo barcode $'\t' reads_mapped >> {OUT_DIR}/mapping_stats.tsv

for dir in $IN_DIR/*/

do 
	cd $dir
	echo $dir 
	barcode=$(basename $dir)
	echo $barcode
	
	#use samtools stats to get the number of mapped reads 
	mapped_number=$(samtools stats reads.sorted.bam | grep "reads mapped:" | awk '{print $4}')
	echo $mapped_number
	echo $barcode $'\t' $mapped_number >> ${OUT_DIR}/mapping_stats.tsv 

done
