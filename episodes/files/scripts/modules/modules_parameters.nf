
params.message = 'parameter from workflow script'

include { sayMessage } from './modules/module.nf'

workflow {
    sayMessage()
}
