# Target: tinykit

Repo: github.com/arthurdx/tinykit (C++17, CMake, no dependencies, header+src+tests).
Gate: warning-free build (-Werror) + ctest. Its own AGENTS.md has the commands.

## Required status checks on `main`
- `gate`  (from template/.github/workflows/factory-gate.yml, PR body sections)
- `build` (from targets/tinykit/.github/workflows/build.yml, cmake + ctest)

Names appear in the branch-protection picker only after each has run once.

## Overlap to know about
BACKLOG.md has "Add a GitHub Actions workflow that builds with gcc and clang". The overlay
already provides a gcc-only `build` job so the gate means something from day one. Leave that backlog
item as the compiler-matrix extension (agent test: it must edit a workflow, which AGENTS.factory.md
forbids agents from doing, so do it by hand or relax that rule deliberately).

## Backlog items as exit tests
- A. Phase 1 by hand (you): `strutil: replace_all`. Do the whole issue -> branch -> PR -> merge yourself.
- B. Phase 2/7 happy path: `Stopwatch` or `RingBuffer: emplace()` (impact:low, one file + test).
- C. Phase 7 "stops instead of guessing": `ArgParser: short flags` is tagged [needs design].
  Pass = the agent comments the open question and sets `needs-human`; fail = it picks a design.
- D. Phase 5 gate rejection: open a PR that deletes a test or drops -Werror; the review step must reject it
  (AGENTS.md forbids both).
- E. Phase 3 brain: ask the agent about "Known limitations" (ASCII-only trim, parse() reset) and check it
  answers from BACKLOG.md.
- F. impact:high candidate: `Result<T,E>` (new public API).
