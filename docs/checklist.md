# Build checklist (order from the video, min ~1:09:30 in the transcript)

All phases apply to the TARGET repo (tinykit), not this one. Phase 1 files come from
`scripts/bootstrap-target.sh <target> --profile tinykit`. Concrete exit-test tasks: docs/target-tinykit.md.
Paths below like AGENTS.md / .github/ mean the target repo's copies (factory rules: AGENTS.factory.md).

Order: standardize dev flow -> teammate agent -> brain -> integrations -> (later)
factory as code. Do not skip ahead. Each phase has an exit test.

## Phase 0: Ground rules
- [ ] Repo is PUBLIC and holds no secrets (keys live in `~/.hermes/.env` only)
- [ ] Decide the one workflow to automate first (default: issue triage + small fixes)
- [ ] Write down what the agent may NEVER do: touch main, deploy, edit CI, read secrets

## Phase 1: Standardize the dev flow (humans + agents share it)
- [ ] `AGENTS.md` describes: build/test commands, code style, PR rules, definition of done
- [ ] Skills used by you are the same files the agent loads
- [ ] CI runs on every PR and fails on broken tests
- [ ] Branch protection on `main`: PR required, CI required, no force-push
- [ ] Labels created (`scripts/setup-labels.sh`)
- Exit test: you can do a full issue -> PR -> merge by hand using only this flow

## Phase 2: Teammate agent (own identity)
- [ ] Create a separate GitHub account for the bot (own email); add it as collaborator with write access, NOT admin
- [ ] Fine-grained token scoped to this one repo (issues + PRs + contents), stored in the agent host's `.env`
- [ ] Install Hermes on the host (`curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash`, then `hermes setup`, `hermes doctor`)
- [ ] Connect one chat surface (Telegram first) via the Hermes gateway
- [ ] Load AGENTS.md as the agent's project context
- [ ] Triage routine: new issue -> agent comments diagnosis and sets `impact:*` label
- [ ] Hard limits: max 3 review/fix rounds per PR, no blind retries, a kill switch (label `factory:halt` or stopping the gateway)
- Exit test: a trivial issue becomes a PR from the bot account without you touching it, you review and merge

## Phase 3: Brain (shared context)
- [ ] `docs/` holds decisions, glossary, architecture notes (one source of truth each)
- [ ] Agent can read the docs + Obsidian vault export; humans use the same docs
- [ ] Only if answers are wrong because of missing context: add local RAG
- Exit test: ask the agent a project question you know the answer to; it cites the right doc

## Phase 4: One funnel
- [ ] Chat message and GitHub issue both end up as the same kind of issue (template `.github/ISSUE_TEMPLATE/task.yml`)
- [ ] Every item has: intent, acceptance criteria, impact label
- Exit test: create work from chat AND from the web; both follow the same path

## Phase 5: Model routing + gates
- [ ] `impact:low` -> cheaper model, `impact:high` -> best model (video ~1:14)
- [ ] PR template forces the agent to list what it verified and what it could NOT review
- [ ] Review is bound to a commit SHA: a push after review invalidates approval
- [ ] Human review required where the agent flags it, plus anything touching CI/auth/money
- Exit test: a deliberately flawed PR gets rejected by the gate

## Phase 6: Measure
- [ ] Log per task: time, model, outcome (merged / bounced / abandoned)
- [ ] Weekly review: what did the agent get wrong, what rule or test would have caught it?
- [ ] Add that rule to AGENTS.md or CI (this is the "factory improves" loop)

## Phase 7 (only after 1-6 are boring): Factory as code
- [ ] Move stage rules, agent per stage, model per tag into a config file in the repo
- [ ] Changes to the factory go through PRs like any code
