#!/bin/bash
#SBATCH --job-name=rarefaction_vcf
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=24:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out

module load python
source activate /global/home/users/chandlersutherland/anaconda3/envs/nanopore

IN_DIR=/global/scratch/users/chandlersutherland/
TSTAMP=$(date +%Y%m%d-%H%M%S)

depth=(200000 2000 1000 500 250 100 75 50 25)

for i in "${depth[@]}"
do 
    echo "mpileup for depth $i"
    bcftools mpileup \
    -Ou \
    -f $IN_DIR/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa \
    -d $i \
    -a FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,FORMAT/SP,INFO/AD,INFO/ADF,INFO/ADR \
    -r Chr1:26148811-26151472 \
    --threads 20 \
	$IN_DIR/20210831_pass_chopped.minimap2.sorted.sam |\
    bcftools call \
    -m -Ov \
    --threads 20	\
    -o $IN_DIR/rarefaction/20210831_rarefaction_$i.vcf
    echo "vcf file for depth $i created"
done
