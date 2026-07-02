
include { INDEX; QUANT } from './modules/rnaseq-tasks.nf'

workflow {

    reads = Channel.fromFilePairs( '${projectDir}/../../data/yeast/reads/*_{1,2}.fq.gz' )
    transcriptome_ch = Channel.fromPath( '${projectDir}/../../data/yeast/transcriptome/*.fa.gz' )
    INDEX( transcriptome_ch )
    QUANT( INDEX.out,reads )
}
