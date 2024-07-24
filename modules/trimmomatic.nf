process TRIMMOMATIC {
    //trim low quality bases from reads
    publishDir "${params.outputDir}/fastq/trimmed", mode: 'copy', pattern: "*${fastq_R1_trimmed}"
    publishDir "${params.outputDir}/fastq/trimmed", mode: 'copy', pattern: "*${fastq_R2_trimmed}"
    publishDir "${params.outputDir}/fastq/trimmed/stats", mode: 'copy', pattern: "*.txt"

    input:
    tuple val(sampleID), path(fastq_1), path(fastq_2), path(trimmomatic_contaminant_fa)

    output:
    tuple val(sampleID), path("*.trim.fastq.gz"), emit: trimmed_fastq_reads
    path("*.unpaired.fastq.gz"), emit: unpaired_fastq_reads
    path("*.reads.txt"), emit: trimmed_fastq_read_stats

    script:
    prefix = "${sampleID}"
    fastq_R1_trimmed = "${prefix}_R1.trim.fastq.gz"
    fastq_R2_trimmed = "${prefix}_R2.trim.fastq.gz"
    fastq_R1_unpaired = "${prefix}_R1.unpaired.fastq.gz"
    fastq_R2_unpaired = "${prefix}_R2.unpaired.fastq.gz"
    num_reads_trim = "${prefix}.trim.reads.txt"
    num_reads_trim_R1 = "${prefix}_R1.trim.reads.txt"
    num_reads_trim_R2 = "${prefix}_R2.trim.reads.txt"
    num_reads_unpaired_R1 = "${prefix}_R1.unpaired.reads.txt"
    num_reads_unpaired_R2 = "${prefix}_R2.unpaired.reads.txt"

    """
    java -jar /opt/trimmomatic.jar PE -threads \${NSLOTS:-\${NTHREADS:-1}} \
    "${fastq_1}" "${fastq_2}" \
    "${fastq_R1_trimmed}" "${fastq_R1_unpaired}" \
    "${fastq_R2_trimmed}" "${fastq_R2_unpaired}" \
    ILLUMINACLIP:${trimmomatic_contaminant_fa}:2:30:10:1:true TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:3

    # get the number of reads
    zcat "${fastq_R1_trimmed}" | awk '{s++}END{print s/4}' > "${num_reads_trim}"
    cp "${num_reads_trim}" "${num_reads_trim_R1}"
    zcat "${fastq_R2_trimmed}" | awk '{s++}END{print s/4}' > "${num_reads_trim_R2}"
    zcat "${fastq_R1_unpaired}" | awk '{s++}END{print s/4}' > "${num_reads_unpaired_R1}"
    zcat "${fastq_R2_unpaired}" | awk '{s++}END{print s/4}' > "${num_reads_unpaired_R2}"
    """
}