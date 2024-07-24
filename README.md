# Nextflow pipeline for proof of concept testing 
Pipeline uses samplesheet with path to fastqs as input. Fastq files are trimmed for low quality reads using trimmomatic, aligned using bwa and summary metrics are generated using samtools flagstat.

## Install and execution

1. Install Docker on your computer. Follow instructions from official docker documentation https://docs.docker.com/. 
2. Clone this repo first
   ```
   git clone --recursive https://github.com/varshini712/nf-test-awspoc.git
   cd nf-test-awspoc
   ```
3. Install Nextflow (version 24.04.3.5916), requires Java 11 or later
   ```
   curl -s https://get.nextflow.io | bash
   ```
4. Change/provide the paths for testdata and reference directories. If local (provide the directory locations), if using AWS (provide the S3 locations for your reference and testdata). Example directory structure is here:
   <img width="703" alt="workflow-structure" src="https://github.com/user-attachments/assets/d5072d6a-0227-4dce-b6e5-a6b6bb7e1c37">

6. Execute the pipeline.
   ```
   ./nextflow run main.nf
   ```

## Software
- Nextflow
- Docker
