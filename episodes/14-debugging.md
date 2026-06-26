---
title: Debugging and troubleshooting
teaching: 30
exercises: 15
---

:::::::::::::::::::::::::::::::::::::::: questions

- A task failed — where do I look?
- What are all the hidden files in a work directory?
- How do I reproduce a failing command by hand?
- Why did `-resume` re-run a task I didn't change?

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: objectives

- Read and interpret a Nextflow error message.
- Inspect the contents of a task's work directory.
- Re-run a failed command manually to debug it.
- Understand common causes of cache misses with `-resume`.
- Use stub runs to test pipeline logic quickly.

::::::::::::::::::::::::::::::::::::::::::::::::::

Pipelines fail. The skill that separates a frustrated beginner from a productive Nextflow user is knowing exactly where to look. Almost every answer is in the **work directory** of the failing task.

## Reading the error message

When a task fails, Nextflow prints a block like this:

```output
ERROR ~ Error executing process > 'INDEX (1)'

Caused by:
  Process `INDEX (1)` terminated with an error exit status (127)

Command executed:
  salmon index --threads 1 -t transcriptome.fa.gz -i index

Command exit status:
  127

Command output:
  (empty)

Command error:
  .command.sh: line 2: salmon: command not found

Work dir:
  /home/user/work/3b/a1f2c9d4e5...
```

Read it from the bottom up:

- **Work dir** — the directory containing everything about this task. Your first stop.
- **Command error** — the captured `stderr`. Here, `salmon: command not found` tells us the tool isn't on the `PATH` (a software/environment problem, not a pipeline-logic problem).
- **Command exit status** — `127` conventionally means "command not found"; `1` is a general error; `137` usually means the task was killed for exceeding its memory limit.
- **Command executed** — the exact command Nextflow ran, with variables already substituted.

## The work directory

`cd` into the reported work directory and list **all** files, including hidden ones:

```bash
$ cd /home/user/work/3b/a1f2c9d4e5...
$ ls -la
```

You will find several hidden helper files that Nextflow creates for every task:

| File | Contents |
| ---- | -------- |
| `.command.sh` | The script that was run, after variable interpolation. |
| `.command.run` | The full wrapper Nextflow used (container/scheduler setup, etc.). |
| `.command.out` | Captured standard output. |
| `.command.err` | Captured standard error. |
| `.command.log` | Combined out + err. |
| `.exitcode` | The numeric exit status. |
| `.command.begin` | Created when the task starts (useful to confirm it launched). |

The input files for the task are also staged into this directory (usually as symlinks), so the environment is exactly what the command saw.

## Reproduce the command by hand

Because the work directory contains the inputs and the exact script, you can reproduce a failure interactively:

```bash
$ cd /home/user/work/3b/a1f2c9d4e5...
$ bash .command.sh
```

Now you can edit the command, check tool versions, inspect input files, and iterate quickly — without re-running the whole pipeline. Once you have a working command, fix the corresponding process in your script.

::::::::::::::::::::::::::::::::::::::: callout

## Tip: `nextflow log` and the `.nextflow.log` file

`nextflow log` lists previous runs, and `nextflow log <run_name> -f workdir,name,status` will print the work directory of every task so you can find the one you want. The hidden `.nextflow.log` file in your launch directory holds the full, detailed log of the most recent run.

::::::::::::::::::::::::::::::::::::::::::::::::::

## Common `-resume` cache misses

`-resume` re-uses cached results for tasks whose inputs are unchanged (see the [caching episode](10-workflow_checkpoint_caching.md)). If a task you didn't touch re-runs anyway, the usual culprits are:

- **A changed input file.** Nextflow hashes file *content* (and size/timestamp), so editing or re-creating an input invalidates the cache.
- **A changed script or parameter** feeding that process.
- **A non-deterministic input order** — e.g. files read from a directory in OS order. Use a sort or `fromFilePairs` to make ordering stable.
- **Using `Date`, random values, or absolute paths** inside a process, which change between runs.

The `-dump-hashes` option prints the values Nextflow hashed for each task, which lets you see exactly what differed.

## Stub runs for fast iteration

When you are developing pipeline *structure* and don't want to run the real (slow) tools, add a `stub:` block to a process. Running with `-stub-run` executes the stub instead of the real `script`, producing dummy outputs almost instantly so you can test that channels and the workflow wire up correctly.

```groovy
process INDEX {
    input:
    path transcriptome

    output:
    path 'index'

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """

    stub:
    """
    mkdir index
    touch index/stub_index
    """
}
```

```bash
$ nextflow run main.nf -stub-run
```

::::::::::::::::::::::::::::::::::::::: keypoints

- Read errors from the bottom up; the **Command error** and **Work dir** lines tell you most of what you need.
- Every task has hidden `.command.*` files in its work directory.
- Reproduce a failure by running `bash .command.sh` inside the work directory.
- Exit `127` = command not found, `137` = killed (often out of memory).
- `-resume` cache misses usually come from changed inputs, scripts, parameters, or non-deterministic ordering.
- Use a `stub:` block with `-stub-run` to test workflow logic without running the real tools.

::::::::::::::::::::::::::::::::::::::::::::::::::
