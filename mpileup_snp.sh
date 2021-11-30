#!/bin/bash
#SBATCH --job-name=snp_calling
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=00:60:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
module load samtools
source activate nanopore

IN_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/mapped_reads
MPILEUP_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/mpileup
SNP_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/snp
REF=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa

for file in $IN_DIR/*/

do 
	barcode=$(basename $file)
	echo $barcode
	
	bcftools mpileup -Ov \
	-o $MPILEUP_DIR/$barcode.mpileup.vcf \
	-f $REF \
	-d 200000 \
	--threads 20\
	-a FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,FORMAT/SP,INFO/AD,INFO/ADF,INFO/ADR \
	$file
	
	echo("mpileup for $barcode created") 
done

for file in $MPILEUP_DIR/*/

do 
	barcode=$(basename $file)
	echo $barcode
	
	bcftools call -m -Ov \
	--threads 20 \
	-o $SNP_DIR/$barcode.vcf \
	file 
	
	echo("snp file for $barcode created")
done	