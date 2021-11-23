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

module load python 
source activate nanopore

IN_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/fastq_pass/

for dir in $IN_DIR
do 
	cd $dir
	./minimap2 -a /global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.mmi\
	${IN_DIR}/${dir}/merged_file.fastq.gz | \
	samtools sort -o ${IN_DIR}/${dir}/reads.sorted.bam 
	samtools index reads.sorted.bam
done 