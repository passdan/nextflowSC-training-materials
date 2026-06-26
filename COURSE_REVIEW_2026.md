# Course Review — June 2026

> **Status:** All recommendations below have now been implemented, **except** the container-ecosystem additions (item 2.8 / 3.4), which are taught separately, and the external image vendoring (item 2.9), which could not be automated here — see note at the end.

Review of the *Introduction to Nextflow* materials (first written 2024) against the current Nextflow/nf-core landscape.

Reference points (June 2026): Nextflow stable **26.04** (DSL2 only; DSL1 removed in 22.12), nf-core **141 pipelines**, nf-core/tools **4.x**, nf-test now the community testing standard, Seqera Platform (the renamed Nextflow Tower).

---

## 1. README links

Done — the Day 1–3 episode links in `README.md` now point to the local files in `episodes/` instead of the external `carpentries-incubator.github.io` site. External references that are *not* episodes (Nextflow docs, nf-core.re, the Google Slides/video, Seqera blog) were deliberately left pointing outwards.

---

## 2. Accuracy / relevance updates

### High priority

1. **Inconsistent Nextflow versions in console output.** Pasted logs span `20.10` → `24.04` (e.g. `03-channels.md`, `04-processes-part1.md`, `05-processes-part2.md`). Re-run examples on one current version (26.04) so output, timing lines and the run banner are consistent.
2. **`publishDir` is now deprecated.** Episodes 05 and 11 teach `publishDir` as the primary way to publish results. As of 25.10 the **workflow `output` / `publish` block** is the finalised, recommended approach; `publishDir` still works but is deprecated. Introduce the new syntax as the default and keep `publishDir` as a "you'll see this in older pipelines" note.
3. **DSL2 framing.** Materials still imply DSL2 is a choice. DSL1 was removed in 22.12, so `nextflow.enable.dsl=2` is no longer needed and DSL2 is simply "Nextflow". Drop any DSL1-vs-DSL2 caveats.
4. **Tool/version pins are stale.** Salmon 1.3.0, FastQC 0.11.9 etc. appear in figures and `environment.yml` files. Bump to current releases and check the conda channel syntax still resolves.

### Medium priority

5. **Strict syntax / language server.** The strict parser is on by default in 26.04 and the VS Code Nextflow extension (language server) is now standard tooling. Worth a short note so learners' editors don't surprise them with new linting errors.
6. **`nf-core/tools` 4.x commands.** Episode 12 should be checked against tools 4.x — command names, `nf-core pipelines list/launch/download` subcommand structure, and the pipeline count (141) all changed since 2024.
7. **Seqera Platform naming.** Anywhere "Tower" appears, update to "Seqera Platform". Worth one sentence on `-with-tower`/`tower.enabled` still being the runtime hooks.
8. **Container ecosystem.** Episode 09 covers Docker/Singularity/Conda. Add a mention of **Wave** (on-the-fly container builds) and **Fusion** (file system), now mainstream and heavily used by nf-core/Seqera.
9. **Image hotlinks.** `01-getting-started` pulls figures from a third-party site (`sateeshperi.github.io`) and Springer. These can break — vendor them into `episodes/fig/`.

### Low priority

10. **`Channel.from` / `Channel.fromList`.** Already flagged as deprecated in `03-channels.md` — good. Just confirm no live example still uses `Channel.from`.
11. Seqera "Learn Nextflow in 2023" link in the README footer points to a dated blog; swap for the current `training.nextflow.io`.

---

## 3. Missing gaps for an introductory course

Genuinely missing, in rough priority order:

1. **Testing with nf-test.** The single biggest gap. nf-test is now the community standard and part of nf-core's CI. Even a short "write one test for a process" section materially raises the course's currency.
2. **Workflow outputs (`output`/`publish` block).** As above — this is now *the* way to handle results and deserves its own short section, not just a footnote in the process episode.
3. **Modules and `include` / code organisation.** Coverage of importing processes from `modules/` and structuring a real pipeline is thin. nf-core is built on this, so it bridges naturally into episode 12.
4. **Containers from the learner's side.** How to actually *get* a container running (`-profile docker/singularity`, biocontainers, Seqera Containers/Wave) rather than only configuring directives.
5. **Debugging & troubleshooting.** Reading the `.command.*` files in a work dir, interpreting common errors, `-resume` cache misses. New users hit this constantly and it's barely covered.
6. **Samplesheet / CSV-driven input** with `splitCsv`, the dominant real-world input pattern (and the nf-core convention). Operators episode touches channels but not this idiom.
7. **Pipeline parameter validation** via the `nf-schema` plugin (`nextflow_schema.json`) — how nf-core validates inputs.
8. **Seqera Platform / monitoring** — even a brief orientation, since most learners will encounter it for cloud/HPC runs.
9. **`nextflow.config` best practices & version pinning** (`manifest.nextflowVersion`, reproducible runs) — currently config is taught mechanically without the "make it reproducible" framing.

### Smaller additions
- A one-page **glossary** (process, channel, operator, executor, work dir, profile).
- **Cloud/HPC executor** worked example (Slurm or AWS Batch) beyond the config snippet.
- Note on **`-stub`/stub runs** for fast pipeline development.

---

## What was changed (June 2026 implementation)

- **README** — episode links point to local files; footer link updated to `training.nextflow.io`; schedule now lists the new episodes.
- **Version banners** — all console output standardised to Nextflow `26.04.2`; obsolete `nextflow.enable.dsl = 2` lines removed across episodes and scripts; tool pins bumped (salmon 1.10.3, fastqc 0.12.1, multiqc 1.21, fastp 0.23.4).
- **Episode 01** — added a callout on DSL2-only, strict syntax, and the VS Code language server.
- **Episode 02** — added a section on parameter validation with the `nf-schema` plugin.
- **Episode 05** — workflow `output`/`publish` block taught as the recommended approach; `publishDir` reframed as legacy with a deprecation callout.
- **Episode 07** — added the sample-sheet → `[meta, reads]` map pattern.
- **Episode 08** — added a section on live monitoring with the Seqera Platform.
- **Episode 09** — added a SLURM/AWS Batch worked example and a reproducibility/version-pinning callout (`manifest.nextflowVersion`, `-r`).
- **Episode 11** — pointer to workflow outputs added alongside the `publishDir` exercise.
- **Episode 12** — nf-core commands updated to the `nf-core pipelines <cmd>` 3.0+/4.x structure; tools version 4.0.2; pipeline count noted; restructure callout added.
- **New episodes** — `13-modules.md` (modules & `include`), `14-debugging.md` (troubleshooting, work dir, `-resume`, stubs), `15-testing-nf-test.md` (nf-test).
- **New reference** — `learners/reference.md` glossary.
- **config.yaml** — new episodes added to the lesson order.

### Not done automatically
- **External image vendoring** (item 2.9) — figures in `01-getting-started` are hotlinked from `sateeshperi.github.io` and Springer. Downloading third-party images could not be automated in this environment; recommend manually saving them into `episodes/fig/` and updating the `<img src>` paths. The alt-text tool versions (Salmon 1.3.0, FastQC 0.11.9) describe those external images and were left unchanged.
- **Container ecosystem** (Wave/Fusion, items 2.8 / 3.4) — intentionally omitted; taught separately.
