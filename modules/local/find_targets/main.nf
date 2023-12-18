// FIND_TARGETS
//
// Currently only does CAT

process FIND_TARGETS {

    tag "$meta.id"
    label 'process_medium'

   container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://mskcc/mjolnir:0.1.0':
        'docker.io/mskcc/mjolnir:0.1.0' }"

    input:
    tuple val(meta), path(bams), path(bam_indices)

    output:
    tuple val(meta), path('*.ft.bed')  , emit: ft_bed 
    path "versions.yml"                , emit: versions

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def assay = task.ext.assay ?: "${meta.assay}"
    def bam_tumor = "${bams[0]}"
    def bam_normal = "${bams[1]}"
    def output_file = "${meta.id}.ft.bed"
    //$projectDir/bin/my_bash_script.sh <command>
    """
    echo find_targets ${bam_tumor}, ${bam_normal}, ${assay} > ${output_file}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mjolnir: 0.1.0
    END_VERSIONS
    """
}
