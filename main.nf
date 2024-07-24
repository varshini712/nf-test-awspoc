#!/usr/bin/env nextflow

include { AWS_POC } from './workflows/aws_poc.nf'

workflow {
    AWS_POC()
}