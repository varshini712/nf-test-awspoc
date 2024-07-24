process ALIGNMENT {
    // first pass alignment with BWA
    publishDir "${params.outputDir}/alignments/raw", mode: 'copy'

    input:
    tuple val(sampleID), path(trimmed_reads)
    path(ref_genome)

    output:
    tuple val(sampleID), path("${bam_file}"), emit: raw_bam

    script:
    prefix = "${sampleID}"
    bam_file = "${prefix}.bam"

    """
    bwa mem \
    -M -v 1 \
    -t \${NSLOTS:-\${NTHREADS:-1}} \
    -R '@RG\\tID:${sampleID}\\tSM:${sampleID}\\tLB:${sampleID}\\tPL:ILLUMINA' \
    "${ref_genome}/genome.fa" \
    "${trimmed_reads[0]}" "${trimmed_reads[1]}" | \
    sambamba view \
    --sam-input \
    --nthreads=\${NSLOTS:-\${NTHREADS:-1}} \
    --filter='mapping_quality>=10' \
    --format=bam \
    --compression-level=0 \
    /dev/stdin | \
    sambamba sort \
    --nthreads=\${NSLOTS:-\${NTHREADS:-1}} \
    --out="${bam_file}" /dev/stdin
    """

}