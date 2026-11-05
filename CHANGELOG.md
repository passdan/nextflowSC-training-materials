# Changelog

Notable changes to these training materials. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased] — Nextflow 26.04

Brings the materials in line with Nextflow 26.04, which enabled the strict syntax parser by default and deprecated or removed several patterns used throughout the course. Sources: the Nextflow [Migrating to 26.04](https://docs.seqera.io/nextflow/migrations/26-04) and [Deprecations](https://docs.seqera.io/nextflow/deprecations) pages.

### Changed

- **Channel factories lower-cased throughout.** 158 occurrences of `Channel.of`, `Channel.fromPath`, `Channel.fromList`, `Channel.fromFilePairs`, `Channel.fromSRA`, `Channel.value` and `Channel.empty` changed to the lower-case `channel.` form, across 67 episode and script files. The capitalised form was deprecated in 25.10.
- Episode 01: added a note explaining the lower-case channel factory convention, so learners are not surprised by older code.

### Fixed

- **`echo` directive replaced with `debug`** in 6 places (`09-configuration.md` ×3, `print_message.nf`, `process_combine_03.nf`, `process_directive.nf`). `echo` was deprecated in 22.04 and **removed in 26.10**, so these would have failed outright.
- Episode 01 and the glossary: corrected the DSL1 removal version. It was deprecated in 22.04 and removed in **23.04**, not 22.12. Also noted that the `nextflow.enable.dsl` feature flag itself was deprecated in 25.04.

### Documented as deprecated

These remain in the materials because learners will meet them in existing pipelines, but each now carries a warning rather than being taught as current practice.

- `04-processes-part1.md`: the process `shell` section, deprecated 25.04. Note added pointing to `script` and explaining Bash variable escaping.
- `04-processes-part1.md` and `05-processes-part2.md`: the process `when` section, deprecated 26.10. Notes added pointing to conditional logic in the calling workflow or the `process.when` config setting.
- `03-channels.md`: `channel.fromSRA`, deprecated 26.04, flagged with a pointer to Entrez Direct.

### Still to do

- [ ] Run `nextflow lint episodes/` against 26.04 and fix whatever the strict parser rejects. From 26.04 the linter and the runtime share a parser, so a clean lint is a strong signal the examples will run.
- [ ] Execute every example end to end against 26.04. Nothing else substitutes for this.
- [ ] Decide on `publishDir`, which appears in roughly 60 places. It is **discouraged** rather than deprecated in favour of the workflow `output` block, and is still widespread, so the suggestion is to keep it as the main thread and add a forward-pointing callout rather than rewriting episodes 04, 05 and 11.
- [ ] Decide on top-level `params.foo = ...` declarations, roughly 98 places. Discouraged in favour of a `params` block. Same reasoning as `publishDir`: widespread in real code, so possibly worth keeping with a note.
- [ ] `episodes/files/scripts/modules/modules_addparams.nf` demonstrates `addParams`, deprecated 24.10. The episode text already recommends explicit inputs and no longer references this script, so it can probably be deleted.
- [ ] Consider adding the 26.04 **module registry** to episode 13: `nextflow module search / install / run`, and including modules by name (`from 'nf-core/bwa/mem'`) rather than by relative path. Probably the most teachable new feature.
- [ ] Consider a callout in episode 04 introducing **records** as a named-field alternative to positional tuples.
- [ ] Consider adding `nextflow lint -project-dir` and `NXF_AGENT_MODE=1` to episode 14.

### Notes for instructors

- **Pin the Nextflow version for the duration of the course.** Map inputs are hashed differently from 26.04, including keys as well as values, so any process with a map input re-executes on the first `-resume` after an upgrade. A learner who upgrades partway through will see episode 10's caching demo behave unexpectedly for reasons unrelated to the lesson.
- `NXF_SYNTAX_PARSER=v1` restores the legacy parser if an example fails live. Useful to rescue a session, not a fix: the legacy parser is itself deprecated as of 26.04.
- The repository currently shows ~123 files as modified under Git purely because of CRLF line endings. Review real changes with `git diff -w` or set `core.autocrlf` before committing.

---

## [2026-07-02]

### Changed

- Converted all `:::` Carpentries fenced blocks to plain markdown headers, so the materials render natively in GitHub, VS Code preview and any markdown viewer with no build step. 52 `<details>` dropdowns for solutions and instructor notes preserved; 43 challenges became `## Exercise:` headings.
