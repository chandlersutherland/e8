#!/bin/bash
#SBATCH --job-name=alt_allele_freq
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
module load bcftools 
source activate nanopore

IN_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/mapped_reads
OUT_DIR=/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/alt_freq
REF=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa
AMPLICONS=/global/scratch/users/chandlersutherland/nanopore/amplicons.bed


for file in $IN_DIR/*

do 
	barcode=$(basename $file .region.bam)
	echo $barcode 
	#first, create a vcf file with all the variants still there (-A flag after -m multivariate caller)
	bcftools mpileup \
	-f $REF \
	-d 200000 \
	--threads 20\
	-a AD \
	-Ou \
	$file |
	bcftools call \
	-mA \
	-Oz -o $OUT_DIR/$barcode.alt.vcf \
	# next, index and filter to just the amplicon region, getting rid of any incorrectly long reads 
	# Get rid of any sites without alt allele (N_ALT==0) 
	bcftools index $OUT_DIR/$barcode.alt.vcf -o $OUT_DIR/$barcode.alt.vcf.csi
	bcftools filter -R $AMPLICONS $OUT_DIR/$barcode.alt.vcf|\
	bcftools view -e N_ALT==0 > $OUT_DIR/$barcode.filtered.alt.vcf
	echo "filtered alt vcf for $barcode created"
done

cd $OUT_DIR
for file in $OUT_DIR/*.filtered.alt.vcf

do 
	barcode=$(basename $file .filtered.alt.vcf)
	echo $barcode
	#Pull out the important information (Chromosome, position, ref call, alternative call, and allelic depth)
	#This is designed to call any secondary alt alleles if present and its allelic depth, but not third etc 
	bcftools query -f "%CHROM\t%POS\t%REF\t%ALT{0}\t[%AD{1}]\n%CHROM\t%POS\t%REF\t%ALT{1}\t[%AD{2}]\n" $file |\
	grep -v '\.' |\
	#attach the barcode to the first row before making a tsv file, allele freq
	sed "s/^/$barcode\t/" >> $OUT_DIR/allele_freq.tsv
	echo "alt allele freqs for $barcode added to allele_freq.tsv"
done 