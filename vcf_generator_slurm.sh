#!/bin/bash
#SBATCH --job-name=vcf_generator
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=24:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL


module load bcftools/1.6 

bcftools mpileup -Ov \
	-o /global/scratch/users/chandlersutherland/20210831_pass_chopped.minimap2.sorted.mpileup.vcf \
	-f /global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa \
	-d 200000 \
	-a FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,FORMAT/SP,INFO/AD,INFO/ADF,INFO/ADR \
	-r Chr1:26150105-26152767\
	--threads 20\
/global/scratch/users/chandlersutherland/20210831_pass_chopped.minimap2.sorted.sam

bcftools call /global/scratch/users/chandlersutherland/20210831_pass_chopped.minimap2.sorted.mpileup.vcf \
	-mv -Ov \
	--threads = 20 \
	-o /global/home/users/chandlersutherland/20210831_fastq_pass_chopped.minimap2.sorted.call.vcf 
