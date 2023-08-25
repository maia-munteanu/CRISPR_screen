#! /usr/bin/env nextflow
//vim: syntax=groovy -*- mode: groovy;-*-
// Copyright (C) 2022 IRB Barcelona

params.sigproassembly = "GRCh37"
params.input_file = "/g/strcombio/fsupek_cancer1/SV_clusters_project/input2.tsv"
params.output_folder = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Cancers/OV_CO_LU_ES_Hartwig_PCAWG_TCGA/"
params.mappability = "/home/mmunteanu/reference/CRG75_nochr.bed"
params.COSMIC_signatures = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Calling/Strelka2/VCFs_SUPEK_24_28_29_30/Signature_databases/COSMIC_V3.3.1_SBS_GRCh37_OGG1.txt"
params.our_signatures = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Calling/Strelka2/VCFs_SUPEK_24_28_29_30/Signature_databases/Our_SBS_signatures.txt"

input_file = file(params.input_file)
mappability = file(params.mappability)
COSMIC_signatures = file(params.COSMIC_signatures)
our_signatures = file(params.our_signatures)

vcf_list = Channel.fromPath(input_file, checkIfExists: true).splitCsv(header: true, sep: '\t', strip: true).map{ row -> [ row.sample, file(row.snv)] }

process parse_vcfs {
       tag { sample }
       input:
       tuple val(sample), file(snv) from vcf_list
       path mappability
       
       output:
       path("${sample}.filt.vcf") into filtered_vcfs
      
       shell:
       '''  
       snvname=$(bcftools query -l !{snv} | sed -n 2p)
       tabix -p vcf !{snv}
       bcftools view -s $snvname -f 'PASS' --regions-file !{mappability} !{snv} | bcftools sort -Ov > !{sample}.filt.vcf
       '''
}

process count_mutations {
    publishDir params.output_folder+"/Counts/", mode: 'copy', pattern: '*.all'
    
    input:
    path "*" from filtered_vcfs.collect()

    output:
    path("*.SBS96.all") into counts_snvs

    shell:
    '''
    mkdir VCFs && mv *filt.vcf VCFs
    python3 !{baseDir}/MatrixGenerator.py "Cancers" !{params.sigproassembly} "./VCFs/"
    cp ./VCFs/output/SBS/Cancers.SBS96.all ./Cancers.SBS96.all
    cp ./VCFs/output/ID/Cancers.ID83.all ./Cancers.ID83.all
   '''     
}

process signature_fitting {
    publishDir params.output_folder, mode: 'move', pattern: "Our_signatures_k11_joint"
    publishDir params.output_folder, mode: 'move', pattern: "COSMIC_signatures_OGG1"

    input:
    path("*.SBS96.all)" from counts_snvs
    path COSMIC_signatures
    path our_signatures

    output:
    path("Our_signatures_k11_joint")
    path("COSMIC_signatures_OGG1")

    shell:
    '''
    python3 !{baseDir}/SignatureAssignment.py Cancers.SBS96.all !{our_signatures} !{COSMIC_signatures} Our_signatures_k11_joint COSMIC_signatures_OGG1
    '''
}
