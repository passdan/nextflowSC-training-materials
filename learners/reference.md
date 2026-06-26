---
title: Reference & Glossary
---

## Glossary

A quick reference to the core Nextflow terms used throughout this course.

**Channel**
: An asynchronous, typed queue that connects processes. Data flows between processes only through channels. Channels are either *queue* channels (consumable, emit many items) or *value* channels (re-usable, emit a single value indefinitely).

**Process**
: The basic unit of work. A process defines inputs, outputs, and a `script` (a command in any language) to execute. Nextflow runs one independent *task* per input set.

**Task**
: A single execution of a process for one set of inputs. If a channel feeds three items into a process, three tasks run (in parallel where possible).

**Workflow**
: The block that wires processes together by passing channels between them, defining the execution flow. The unnamed `workflow {}` is the *entry* workflow; named workflows act as reusable sub-workflows.

**Operator**
: A method applied to a channel to transform, filter, combine, split, or view its contents (e.g. `map`, `collect`, `splitCsv`, `view`).

**Channel factory**
: A method that creates a channel, e.g. `Channel.of`, `Channel.fromPath`, `Channel.fromFilePairs`.

**Executor**
: The component that decides *how and where* a task runs — locally, or on an HPC scheduler (SLURM, SGE, PBS) or cloud platform (AWS Batch, Google Batch, Azure Batch). Set in configuration, independent of the workflow logic.

**Directive**
: A setting attached to a process that controls how its tasks run — e.g. `cpus`, `memory`, `time`, `tag`, `container`, `conda`, `publishDir`.

**Work directory**
: The temporary directory (default `work/`) where each task runs in its own uniquely-named sub-directory, containing staged inputs and the hidden `.command.*` files.

**`publishDir`**
: A (now deprecated) process directive that copies or links selected outputs to a results directory. Superseded by **workflow outputs**.

**Workflow outputs**
: The modern mechanism (`publish:` section in the entry workflow plus a top-level `output {}` block) for publishing results, finalised in Nextflow 25.10. Replaces `publishDir`.

**Module**
: A `.nf` file containing process/function/workflow definitions, imported elsewhere with `include`. The basis of code reuse.

**`include`**
: The statement that imports components from a module, e.g. `include { FOO } from './modules/foo.nf'`.

**Configuration profile**
: A named bundle of settings in `nextflow.config` (e.g. `docker`, `singularity`, `test`, `slurm`) activated at runtime with `-profile <name>`.

**Parameter (`params`)**
: A pipeline-level input, e.g. `params.input`. Set on the command line with `--input`, or in a `-params-file`.

**`-resume`**
: A run flag that re-uses cached results for tasks whose inputs, script, and parameters are unchanged, so only the affected parts of a pipeline re-run.

**Stub**
: An optional `stub:` block giving a fast dummy implementation of a process, run with `-stub-run` to test workflow structure without executing the real tools.

**DSL2**
: The current (and only) Nextflow domain-specific language, enabling modules and named workflows. The older DSL1 was removed in version 22.12.

**nf-core**
: A community project providing curated, peer-reviewed, best-practice Nextflow pipelines and the `nf-core` helper tools.

**nf-test**
: The community-standard framework for writing automated tests of Nextflow functions, processes, sub-workflows, and pipelines.

**Seqera Platform**
: The hosted service (formerly Nextflow Tower) for launching and monitoring runs, enabled with `-with-tower`.

**Wave / Fusion**
: Seqera technologies for building containers on the fly (Wave) and providing a fast file system for cloud/HPC work directories (Fusion). *(Covered separately in this course.)*
