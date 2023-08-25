#!/usr/bin/env python3
import sys
import os
from SigProfilerAssignment import Analyzer as Analyze


samples_SNVs = sys.argv[1]
database_ours = sys.argv[2]
database_cosmic = sys.argv[3]
output_ours = sys.argv[4]
output_cosmic = sys.argv[5]

def main_function():
     matrices = matGen.SigProfilerMatrixGeneratorFunc(project, genome, output, plot=False, exome=False, bed_file=None, chrom_based=False, tsb_stat=False, seqInfo=False, cushion=100)
     Analyze.cosmic_fit(samples_SNVs, output_ours, input_type="matrix", context_type="96",
                   collapse_to_SBS96=True, cosmic_version=3.3, exome=False,
                   genome_build="GRCh37", signature_database=database_ours,
                   exclude_signature_subgroups=None, export_probabilities=False,
                   export_probabilities_per_mutation=False, make_plots=False,
                   sample_reconstruction_plots=False, verbose=False)
if __name__=="__main__":
   main_function()

def main_function():
     matrices = matGen.SigProfilerMatrixGeneratorFunc(project, genome, output, plot=False, exome=False, bed_file=None, chrom_based=False, tsb_stat=False, seqInfo=False, cushion=100)
     Analyze.cosmic_fit(samples_SNVs, output_cosmic, input_type="matrix", context_type="96",
                   collapse_to_SBS96=True, cosmic_version=3.3, exome=False,
                   genome_build="GRCh37", signature_database=database_cosmic,
                   exclude_signature_subgroups=None, export_probabilities=False,
                   export_probabilities_per_mutation=False, make_plots=False,
                   sample_reconstruction_plots=False, verbose=False)
if __name__=="__main__":
   main_function()

