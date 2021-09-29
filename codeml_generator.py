in_dir = '/global/scratch/users/chandlersutherland/pamL' 
codeml_temp = '/global/scratch/users/chandlersutherland/codeml.ctl' 

#remove the first three lines of the codeml file template, and store as codeml_contents
with open(codeml_temp,'r') as file:
    codeml_contents = file.readlines()
    codeml_contents = codeml_contents[3:]

import os 
dir_list = os.listdir(in_dir) 

for dir in dir_list:
  filename = "codeml.ctl"
  fh = open(in_dir + str(dir) + "/" + filename, 'w')
  line1 = "      seqfile = " + str(dir) + "_paml.nuc.phy"
  line2 = "     treefile = RAxML_bipartitionsBranchLabels." + str(dir) + "_pamL.20210922-154758.raxml"
  line3 = "      outfile = " + str(dir) + "_paml.mlc"
  header = "\n".join([line1, line2, line3])
  fh.write(header +"\n")
  fh.writelines(codeml_contents)
  fh.close()