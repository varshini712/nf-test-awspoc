process SAMTOOLS_FLAGSTAT {
    // alignment stats for bam
    publishDir "${params.outputDir}/alignments/stats", mode: 'copy'

    input:
    tuple val(sampleID), path(bam)

    output:
    path("${flagstat}"), emit: alignment_flagstats
    tuple val(sampleID), path("${flagstat}"), emit: sample_flagstat

    script:
    prefix = "${sampleID}"
    flagstat = "${prefix}.flagstat.txt"

    """
    samtools flagstat "${bam}" > "${flagstat}"
    """
}

