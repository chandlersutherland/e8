#!/bin/bash
#SBATCH --job-name=depth_analysis
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
DEPTH_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/depth
AMPLICONS=/global/scratch/users/chandlersutherland/nanopore/amplicons.bed

for dir in $IN_DIR/*/

do 
	cd $dir
	echo $dir 
	barcode=${$dir##*/}
	echo $barcode
	
	#filter the .bam files to be just the amplicon regions
	samtools view -b -h -L ${AMPLICONS} -o ${OUT_DIR}/${barcode}.region.bam reads.sorted.bam

	#use the innate samtools depth filter to calculate depth for each amplicon
	samtools depth -b ${AMPLICONS} -o ${DEPTH_DIR}/${barcode}.depth.tsv

done
