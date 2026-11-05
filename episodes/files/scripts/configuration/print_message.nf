
params.message = 'hello'

workflow {
    PRINT_MESSAGE(params.message)
}

process PRINT_MESSAGE {
    debug true

    input:
    val my_message

    script:
    """
    echo $my_message
    """
}
