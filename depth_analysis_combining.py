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

import os 
import pandas as pd

DEPTH_DIR='/global/scratch/users/chandlersutherland/nanopore/20211109_CS/S3/20211109_1827_MN35019_AIH759_d0d0cd8b/depth'
AMPLICONS='/global/scratch/users/chandlersutherland/nanopore/amplicons.bed'
amp_position = pd.read_csv(AMPLICONS, sep='\t', header=0, names=['Chromosome', 'start', 'end', 'marker', 'code'], index_col=False)

depth_file = pd.DataFrame()
for FILE in os.listdir(DEPTH_DIR):
	basename = os.path.basename(FILE)
    barcode = basename.split(".")[0]
    depth=pd.read_csv(FILE, sep='\t', header=None, names=['Chromosome', 'Position', 'depth'], index_col=False)
    depth['Marker']=''
    
    for j in range(0, len(depth)): 
        for i in range(0, len(amp_position)): 
            if depth.iloc[j, 0] == amp_position.iloc[i, 0]:
                if amp_position.iloc[i, 1] <= depth.iloc[j, 1] <= amp_position.iloc[i, 2]:
                    depth.iloc[j, 3] = amp_position.iloc[i, 3]
    
    depth['Barcode']= barcode
    pd.concat([depth_file, depth])