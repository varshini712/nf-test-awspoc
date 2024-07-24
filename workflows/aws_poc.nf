include { TRIMMOMATIC } from '../modules/trimmomatic.nf'
include { ALIGNMENT } from '../modules/alignment.nf'
include { SAMTOOLS_FLAGSTAT } from '../modules/samtools.nf'


workflow AWS_POC {
    // Create input channel from input file provided through params.input
    ch_sampleinput = Channel.fromPath(file(params.samplesheet)) \
            . splitCsv( header: true ) \
            . map { row -> tuple(row.sample, file(row.fastq_1), file(row.fastq_2))}
    
    //Trim and alignment channels
    ch_trimmomatic_contaminant_fa = Channel.fromPath(params.trimmomatic_contaminant_fa)
    ch_trim = ch_sampleinput.combine(ch_trimmomatic_contaminant_fa)
    TRIMMOMATIC(ch_trim)

    ch_ref_genome =  Channel.fromPath("${params.ref_fa_bwa_dir}")
    ALIGNMENT(TRIMMOMATIC.out.trimmed_fastq_reads,ch_ref_genome.first())

    SAMTOOLS_FLAGSTAT(ALIGNMENT.out.raw_bam)

}