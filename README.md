# Software Factory V2 (free-tier PoC)

Personal learning experiment: reproduce the "agentic software factory V2" loop
(humans own intent and review, a teammate agent owns triage and implementation)
using only free or very cheap tools. Based on the material in `refs/`.

Two repos:
- this one (`sw-factory`): the reusable kit, docs and scripts
- the target (`tinykit`, a small C++17 library): the product the agent works on

Layout:
- `template/`: files copied into every managed repo (issue form, PR template,
  `factory-gate` workflow, `AGENTS.factory.md`). Keep it project-agnostic.
- `targets/<name>/`: per-project overlay (extra workflows). Currently `tinykit/` (CMake build + ctest).
- `scripts/bootstrap-target.sh <dir> --profile tinykit`: copies template + overlay into a
  target working tree and appends a pointer to its AGENTS.md. Never commits; skips existing files unless `--force`.
- `scripts/setup-labels.sh`: creates the factory labels (needs `gh`; otherwise create them in the browser).
- `docs/free-tier-stack.md`: tool per layer, quotas, Brazil-first hosting options and prices
- `docs/checklist.md`: phased build plan with exit tests (applied to the target repo)
- `docs/target-tinykit.md`: how tinykit's backlog maps to the checklist exit tests
- `tasks/`: todo and lessons
