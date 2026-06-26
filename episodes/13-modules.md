---
title: Modules and code organisation
teaching: 30
exercises: 15
---

## Questions

- How do I split a large pipeline into reusable pieces?
- How do I import a process from another file?
- How do I share or rename processes between workflows?

## Objectives

- Understand why modularising a pipeline is good practice.
- Move a process into a module file.
- Import processes into a workflow with the `include` statement.
- Import a process under a different name using an alias.

## Why modules?

So far we have written each process in the same file as the workflow. This is fine for short scripts, but as a pipeline grows it becomes hard to read, hard to test, and impossible to reuse a process in another pipeline without copy-pasting it.

A **module** is simply a Nextflow script that contains one or more process (or function, or workflow) definitions, written so it can be imported elsewhere. Splitting your processes into modules is the foundation of how every nf-core pipeline is built, and it is the single most important habit for writing maintainable Nextflow.

The benefits:

- **Reusability** — the same process can be imported by many pipelines.
- **Readability** — the entry workflow reads as a high-level description of the analysis, not a wall of process code.
- **Testability** — a module can be tested in isolation (see the [testing episode](15-testing-nf-test.md)).

## A module file

A module file is an ordinary `.nf` file containing process definitions and **no** workflow block. For example, `modules/rnaseq-tasks.nf` defines an `INDEX` process:

```groovy
//modules/rnaseq-tasks.nf
process INDEX {

    input:
    path transcriptome

    output:
    path 'index'

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}
```

## Importing with `include`

To use a process defined in a module, use the `include` statement at the top of your workflow script. It names the process (or processes) you want and the file they come from:

```groovy
//modules_index.nf
include { INDEX } from './modules/rnaseq-tasks.nf'

workflow {
    transcriptome_ch = Channel.fromPath('data/yeast/transcriptome/*.fa.gz')
    INDEX( transcriptome_ch )
}
```

A few rules:

- The path is **relative to the importing script** and must start with `./` (or `../`), or be an absolute path.
- You can import several components at once: `include { INDEX; QUANT } from './modules/rnaseq-tasks.nf'`.
- A process can only be imported and used; you can include the same module in many workflows.

## Exercise: Add a module

Using the scripts in `scripts/modules/`, modify `modules_exercise_add_module.nf` so that it also imports and runs the `QUANT` process from `./modules/rnaseq-tasks.nf`, taking the output of `INDEX` and a read-pairs channel as input.

<details>
<summary><b>Solution</b></summary>

```groovy
include { INDEX; QUANT } from './modules/rnaseq-tasks.nf'

params.reads = 'data/yeast/reads/ref1_{1,2}.fq.gz'

workflow {
    transcriptome_ch = Channel.fromPath('data/yeast/transcriptome/*.fa.gz')
    read_pairs_ch    = Channel.fromFilePairs(params.reads)

    index_ch = INDEX(transcriptome_ch)
    QUANT(index_ch, read_pairs_ch)
}
```

(See `modules_exercise_add_module_answer.nf`.)

</details>

## Importing under a different name (aliases)

Sometimes you need to use the same process twice in one workflow — for example, running `FASTQC` on both raw and trimmed reads. Because a process name must be unique within a workflow, you give one of them an **alias** with `as`:

```groovy
include { FASTQC                 } from './modules/qc.nf'
include { FASTQC as FASTQC_TRIM  } from './modules/qc.nf'

workflow {
    FASTQC(raw_reads_ch)
    FASTQC_TRIM(trimmed_reads_ch)
}
```

`FASTQC` and `FASTQC_TRIM` are now two independent instances of the same process. This pattern is used constantly in real pipelines. See `modules_aliases.nf` for a worked example.

## Passing parameters to modules

Modules can read `params` just like the main script. The recommended pattern in modern Nextflow is to pass values **explicitly** as process inputs rather than relying on global `params` inside the module, which keeps modules self-contained and reusable. The example `modules_parameters.nf` shows both approaches.

## Key points

- A module is a `.nf` file of process/function/workflow definitions with no entry workflow.
- Import components with `include { NAME } from './path/to/module.nf'`.
- Import paths are relative to the importing script and must start with `./`, `../`, or be absolute.
- Use `include { NAME as NEW_NAME }` to use the same process more than once.
- Modularising processes is the basis of every nf-core pipeline.
