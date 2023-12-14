// FIND_TARGETS
//
// Currently only does CAT

process FIND_TARGETS {


    tag "$meta.id"
    label 'process_medium'

//   container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
//        'docker://mskcc/mjolnir:0.1.0':
//        'docker.io/mskcc/mjolnir:0.1.0' }"

    input:
    tuple val(meta), path(bam_tumor), path(bai_tumor), path(bam_normal), path(bai_normal), val(assay)

    output:
    tuple val(meta), path(output_file)  , emit: combined
    path "versions.yml"                , emit: versions

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    //$projectDir/bin/my_bash_script.sh <command>
    """
    echo find_targets ${bam_tumor}, ${bam_normal}, ${assay} > ${meta.id}.ft.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mjolnir: 0.1.0
    END_VERSIONS
    """
}
