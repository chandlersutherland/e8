#!/bin/bash
#SBATCH --job-name=raxml_test
#SBATCH --account=fc_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=24:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out


module load raxml/8.2.11

IN_DIR=/global/scratch/users/chandlersutherland/pamL
TSTAMP=$(date +%Y%m%d-%H%M%S)

phyfiles=$(find $IN_DIR -name '*phy')

for FILE in $phyfiles

do 
	echo "FILE: $FILE"
	basename=$(basename $FILE .nuc.phy)
	dirname=$(dirname $FILE)
	raxmlHPC -f a -x 1453 -p 1324 -# 100 -m PROTCATJTT -s $FILE -n ${basename}.${TSTAMP}.raxml -w ${dirname}

done 