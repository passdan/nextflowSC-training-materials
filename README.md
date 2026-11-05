# Introduction to Nextflow 2026 - Bangor Edition

Instructor: Dr. Daniel Pass, Compass Bioinformatics

Welcome to the course! In this github repository we have a range of materials which we are going to use over this three day course:
1. This overview of the course and materials
2. Introduction to Nextflow teaching materials prepared by the Nextflow Developers & Software Carpentry team (of which this project is a fork of) with updates and modifications to reach 2026 standards!. [See their full summary here](README-orig.md)
3. Additional links to documentation, code examples, and exercises
4. Links to presentations & further materials
5. ["Correct" answers](episodes/files/scripts) to the workshop exercises

---
### Schedule
We will be spending three days going from basic introductions to completing a simple RNAseq/metagenomic/DIY workflow. We will follow this rough schedule:

### Day1 
- [Introduction to Nextflow & this course (ppt)](https://docs.google.com/presentation/d/1hs2PyLRzU5ioTUCNr-0bK19wYkUfCAKoSm5RD2FqgZw/edit?usp=drive_link)
- [Coding in a remote environment (video)](https://drive.google.com/file/d/1OjJoj9f84tidXqSxpUZvRekELha8e4GN/view?usp=drive_link)
- [Basic Scripting in Nextflow](episodes/01-getting-started-with-nextflow.md)
  - [(Further Info) Resume & the work dir](episodes/10-workflow_checkpoint_caching.md)
- [Channels](episodes/03-channels.md)
- [Processes](episodes/04-processes-part1.md)
  - [(Further Info) Directives](https://www.nextflow.io/docs/latest/process.html#directives)
  - [(Further Info) PublishDir](https://www.nextflow.io/docs/latest/reference/process.html#publishdir)
### Day 2
- [Workflows](episodes/06-workflow.md)
  - [(Further Info) Named Workflows aka subworkflows](https://www.nextflow.io/docs/latest/workflow.html#named-workflows)
- [Operators](episodes/07-operators.md)
  - [(Further Info) Sample sheets & meta maps](episodes/07-operators.md#building-a-sample-sheet-into-a-meta-map)
- [Configuration](episodes/09-configuration.md)
- [(Further info) Reporting/logs & monitoring](episodes/08-reporting.md)
- [DIY: Making your first pipeline](episodes/11-Simple_Rna-Seq_pipeline.md)
### Day 3
- [Executors & environments](episodes/09-configuration.md)
- [Modules & code organisation](episodes/13-modules.md)
- [Debugging & troubleshooting](episodes/14-debugging.md)
- [Testing with nf-test](episodes/15-testing-nf-test.md)
- [nf-core](episodes/12-nfcore.md)
  - [Pipelines](https://nf-co.re/pipelines)
  - [Modules](https://nf-co.re/modules)
- [What's Next(flow)](https://training.nextflow.io/) - the official Seqera training portal for continued learning
