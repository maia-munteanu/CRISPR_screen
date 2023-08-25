#! /usr/bin/env nextflow
//vim: syntax=groovy -*- mode: groovy;-*-
// Copyright (C) 2022 IRB Barcelona

params.sigproassembly = "GRCh37"
params.input_file = "/g/strcombio/fsupek_cancer1/SV_clusters_project/input2.tsv"
params.output_folder = "/g/strcombio/fsupek_data/MMR_BER_Project/Processed_data/Cancers/OV_CO_LU_ES_Hartwig_PCAWG_TCGA/"
params.mappability = "/home/mmunteanu/reference/CRG75_nochr.bed"
// params.COSMIC_signatures = ""
// params.our_signatures = ""

input_file = file(params.input_file)
mappability = file(params.mappability)

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
    path("*.all") into counts_all

    shell:
    '''
    mkdir VCFs && mv *filt.vcf VCFs
    python3 !{baseDir}/MatrixGenerator.py "Cancers" !{params.sigproassembly} "./VCFs/"
    cp ./VCFs/output/SBS/Cancers.SBS96.all ./Cancers.SBS96.all
    cp ./VCFs/output/ID/Cancers.ID83.all ./Cancers.ID83.all
   '''     
}
