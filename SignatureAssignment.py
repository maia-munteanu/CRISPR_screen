#!/usr/bin/env python3
import sys
import os
from SigProfilerAssignment import Analyzer as Analyze

samples_SNVs = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Calling/Strelka2/VCFs_SUPEK_24_28_29_30/Get_Zou_Kucab_and_merge/Our_Zou_Kucab_SNVs.txt"
database_ours = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Calling/Strelka2/VCFs_SUPEK_24_28_29_30/Signature_databases/Our_SBS_signatures.txt"
database_cosmic = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Calling/Strelka2/VCFs_SUPEK_24_28_29_30/Signature_databases/COSMIC_V3.3.1_SBS_GRCh37_OGG1.txt"

output_SNVs = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Calling/Strelka2/VCFs_SUPEK_24_28_29_30/Our_Zou_signatures_joint/Fittings/Our_Zou_Kucab_SNVs_oursigs"
def main():
        Analyze.cosmic_fit(samples_SNVs, output_SNVs, input_type="matrix", context_type="96",
                   collapse_to_SBS96=True, cosmic_version=3.3, exome=False,
                   genome_build="GRCh37", signature_database=database_ours,
                   exclude_signature_subgroups=None, export_probabilities=False,
                   export_probabilities_per_mutation=False, make_plots=False,
                   sample_reconstruction_plots=False, verbose=False)
if __name__ == '__main__':
    main()

output_SNVs = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Calling/Strelka2/VCFs_SUPEK_24_28_29_30/Our_Zou_signatures_joint/Fittings/Our_Zou_Kucab_SNVs_cosmicOGG1"
def main():
        Analyze.cosmic_fit(samples_SNVs, output_SNVs, input_type="matrix", context_type="96",
                   collapse_to_SBS96=True, cosmic_version=3.3, exome=False,
                   genome_build="GRCh37", signature_database=database_cosmic,
                   exclude_signature_subgroups=None, export_probabilities=False,
                   export_probabilities_per_mutation=False, make_plots=False,
                   sample_reconstruction_plots=False, verbose=False)
if __name__ == '__main__':
    main()
SigProfilerFi
