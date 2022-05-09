import numpy as np
import math
import pandas as pd

#set parameters
n_cells_est = 125000
act_n_gen = 1 + np.log(n_cells_est)/np.log(2)
n_gen = int(act_n_gen)
genome_depth = (2 ** 17) * 2
r = 10 ** -6 
genome = 134634692
coverage = 10235 

# define a function, draw_random_mutation, that for a single base pair given n generations and mutation rate r, will draw from a binomial distribution of mutation probability. If there is a mutation, it will continue for all subsequent cell divisions. 
# n_mut is therefore the number of mutant alleles at this base pair after n cell divisions 
def draw_random_mutation(n_gen, r):
  #Draw a sample out of LD distribution 
  #initialize number of mutations at bp i
  n_mut = 0
  #for each generation, the depth of that mutation is n_mut. Any mutation already present will double as that cell divides  
  for g in range(n_gen):
    n_mut = 2 * n_mut + np.random.binomial(2**(g+1), r)
  return n_mut 

#define sample_random_mutation, which repeats draw_random_mutation over a range of coverage, as in area to be sequenced and returns a vector of mutation depths 
def sample_random_mutation(n_gen, r, coverage):
  #initialize samples vector 
  samples = np.empty(coverage)
  #across the given number of samples, draw random mutations 
  for i in range(coverage):
    samples[i] = draw_random_mutation(n_gen, r)
  return samples 
  
#One leaf, 10 leaves, 100 leaves, 1000 leaves ...
#Define a function, simulator, that when given a number will generate a dataframe of mutant allele frequency summary information 
def simulator(i):
  all_calls = pd.DataFrame()
  for j in range(i):
    #make a df of all calls 
    rm_samples = sample_random_mutation(n_gen, r, coverage).astype(int)
    all_calls[j] = rm_samples
  all_depth = all_calls/(genome_depth)
    #first summary statistic, is the count of sequenceable (>0.002 frequency/iterations) mutations
  sequenceable = all_depth > 0.002
  stat1 = sequenceable.sum().sum()/i 
    #next is the average mutant depth 
  stat2 = all_depth.mean().mean() 
    #we know the min is 0, so the max
  stat3 = all_depth.max().max()
  stats = {'iterations':i, 'sequenceable count': stat1, 'mean vaf': stat2, 'max vaf': stat3}
  #return all_calls
  return stats
  
#summary = pd.DataFrame(columns = ['iterations', 'sequenceable count', 'mean vaf', 'max vaf'])
#for i in range(1, 10000, 100):
 #   sim = simulator(i)
  #  summary = summary.append(sim, ignore_index=True)
   # print(sim)
  
summary.to_csv('mcmc_summary.csv')
#!cp mcmc_summary.csv
