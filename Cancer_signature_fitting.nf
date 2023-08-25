#! /usr/bin/env nextflow
//vim: syntax=groovy -*- mode: groovy;-*-
// Copyright (C) 2022 IRB Barcelona
// example run: nextflow run ../nextflow_pipeline/Mutation_clustering/main3.nf --serial_genome /g/strcombio/fsupek_cancer1/SV_clusters_project/Test/hg19.fa.p --chr_sizes /g/strcombio/fsupek_cancer1/SV_clusters_project/hg19.genome

params.input_file = "/g/strcombio/fsupek_cancer1/SV_clusters_project/Hartwig_TCGA_PCAWG.tsv"
params.output_folder = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Cancers/OV_CO_LU_ES_Hartwig_PCAWG_TCGA/"
params.mappability = "/home/mmunteanu/reference/CRG75_nochr.bed"

vcf_list = Channel.fromPath(input_file, checkIfExists: true).splitCsv(header: true, sep: '\t', strip: true).map{ row -> [ row.sample, file(row.snv)] }

process parse_vcfs {
       tag { sample }
       input:
       tuple val(sample), file(snv) from vcf_list
       path mappability
       
       output:
       tuple val(sample), file("${sample}.filt.vcf") into filtered_vcfs
      
       shell:
       '''  
       snvname=$(bcftools query -l !{snv} | sed -n 2p)
       tabix -p vcf !{snv}
       bcftools view -s $snvname -f 'PASS' --regions-file !{mappability} !{snv} | bcftools sort -Ov > !{sample}.filt.vcf
       '''
}
