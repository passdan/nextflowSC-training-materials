---
title: Testing pipelines with nf-test
teaching: 30
exercises: 20
---

## Questions

- How do I know my pipeline still works after I change it?
- How do I write an automated test for a process?
- What does the nf-core community use to test pipelines?

## Objectives

- Explain why automated testing matters for reproducible pipelines.
- Install nf-test and generate a test for a process.
- Write `when` and `then` blocks with assertions.
- Run the test suite and interpret the results.

## Why test a pipeline?

As a pipeline grows, a change in one process can silently break another. Manually re-running the whole workflow and eyeballing the output does not scale and does not catch subtle regressions. **Automated tests** let you change code with confidence: you run the suite, and it tells you whether outputs still match what you expect.

[nf-test](https://www.nf-test.com/) has become the community-standard testing framework for Nextflow. It is used across all nf-core pipelines and runs in their continuous integration (CI). It can test individual functions, single processes, sub-workflows, and entire pipelines with the same syntax.

## Installing nf-test

nf-test is a single self-contained tool:

```bash
$ curl -fsSL https://get.nf-test.com | bash
```

Or via conda/bioconda:

```bash
$ conda install -c bioconda nf-test
```

Initialise it once per project to create the `nf-test.config` and `tests/` scaffolding:

```bash
$ nf-test init
```

## Generating a test for a process

nf-test can scaffold a test file for you. Given a process `INDEX` in `modules/rnaseq-tasks.nf`:

```bash
$ nf-test generate process modules/rnaseq-tasks.nf
```

This creates a `.nf.test` file next to the module. A test for a single process looks like this:

```groovy
nextflow_process {

    name "Test process INDEX"
    script "modules/rnaseq-tasks.nf"
    process "INDEX"

    test("Builds a salmon index from the yeast transcriptome") {

        when {
            process {
                """
                input[0] = file("\${projectDir}/data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz")
                """
            }
        }

        then {
            assert process.success
            assert process.out.index != null
        }
    }
}
```

### The `when` block

The `when` block defines the **inputs** to the process. Each positional input of the process is set via `input[0]`, `input[1]`, and so on. You can use any Nextflow expression here — channels, `file()`, paths, etc.

### The `then` block

The `then` block contains **assertions** about the result:

- `assert process.success` — the process completed with exit status 0.
- `assert process.out.<name>` — inspect a named output channel.
- `assert process.out.index.get(0) ==~ ...` — check the contents or a checksum of an output.
- `assert snapshot(process.out).match()` — compare every output against a stored "snapshot" (see below).

## Snapshot testing

A powerful feature is `snapshot()`. On the first run nf-test records the outputs (including file checksums) into a `.snap` file; on later runs it checks the outputs still match. This catches any change in results, not just outright failures:

```groovy
then {
    assert process.success
    assert snapshot(process.out).match()
}
```

Commit the `.snap` file to your repository. If an intended change alters outputs, regenerate snapshots with `nf-test test --update-snapshot`.

## Running the tests

```bash
$ nf-test test
```

```output
🚀 nf-test 0.9.x
Process INDEX
  Test [abc123] 'Builds a salmon index from the yeast transcriptome' PASSED (12.3s)

SUCCESS: Executed 1 tests in 12.3s
```

A non-zero exit status and a `FAILED` line tell CI (and you) that something broke.

## Exercise: Write a test for QUANT

Generate and complete a test for the `QUANT` process in `modules/rnaseq-tasks.nf`. Provide an index (you can use the output of a setup step or a small fixture) and a read pair as inputs, and assert that the process succeeds and produces an output directory.

<details>
<summary><b>Solution</b></summary>

A minimal version, using nf-test's `setup` to build the index first:

```groovy
nextflow_process {
    name "Test process QUANT"
    script "modules/rnaseq-tasks.nf"
    process "QUANT"

    setup {
        run("INDEX") {
            script "modules/rnaseq-tasks.nf"
            process {
                """
                input[0] = file("\${projectDir}/data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz")
                """
            }
        }
    }

    test("Quantifies a read pair") {
        when {
            process {
                """
                input[0] = INDEX.out.index
                input[1] = [ 'ref1', [
                    file("\${projectDir}/data/yeast/reads/ref1_1.fq.gz"),
                    file("\${projectDir}/data/yeast/reads/ref1_2.fq.gz")
                ] ]
                """
            }
        }
        then {
            assert process.success
            assert snapshot(process.out).match()
        }
    }
}
```

</details>

## Testing in nf-core

Every nf-core module and pipeline ships with nf-test tests that run automatically on every pull request. When you create a pipeline with `nf-core pipelines create`, the testing scaffolding is generated for you. Writing tests as you go is considered best practice for any production pipeline.

## Key points

- Automated tests let you change a pipeline without silently breaking it.
- nf-test is the community-standard framework and underpins nf-core CI.
- A process test has a `when` block (inputs) and a `then` block (assertions).
- `snapshot()` records and compares full outputs, catching changes in results.
- Run the suite with `nf-test test`; update snapshots with `--update-snapshot`.
