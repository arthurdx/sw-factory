# Free-tier stack for an Agentic Software Factory V2

Prices checked 2026-11-10 from vendor pages / aggregators. Free tiers change
without notice: re-check before depending on any number. Items marked (unverified)
are my judgment, not a vendor statement.

Source model: the "V2 loop" from the Tech Leads Club live (transcript min 3-20):
humans own intent + review, a teammate agent owns triage/implementation, everything
enters through ONE funnel, the agent has its OWN identity.

## 1. Layer map

| Layer | Video | Free / cheap option here | Limits that matter |
|---|---|---|---|
| Work plane: record | Linear | GitHub Issues + Projects (default). Linear Free is the alternative. | Linear Free: 2 teams, 250 issues, 10 MB uploads; API, webhooks and agent platform included. |
| Work plane: intake | Slack | Telegram bot (simplest) or Discord via the Hermes gateway; GitHub issue form for the web path | Video: Discord integrates with little, but a PoC only needs webhooks. Slack Free hides old history (unverified exact window). |
| Control plane: dispatcher | Teammate decides | Labels + GitHub Actions; the agent reads label `impact:*` and picks model | Actions quota below. |
| Control plane: brain | Unblocked (paid) | AGENTS.md + `docs/` in the repo + your Obsidian vault; later local RAG (Chroma/sqlite-vec + Ollama embeddings) | DIY ranking ("which doc is newest") is the hard part. Start without RAG. |
| Teammate agent | Hermes on a VPS | Hermes Agent (open source) + separate GitHub bot account | Needs an always-on host (section 3). |
| Execution plane | Cloud agents / VPS / CI | Local worktree, the VPS, GitHub Actions, Jules free | See quotas below. |
| Validation | Gates + verifier + AI review | CI tests, branch protection, CODEOWNERS, PR template, review bound to commit SHA | All free on GitHub Free for public repos; private repos: branch protection availability on Free private repos (unverified) so keep the PoC repo public. |

## 2. Quotas (verified 2026-11-10)

- GitHub Actions: free for standard runners in PUBLIC repos. Private repos on
  GitHub Free get $12/month of included compute (about 2,000 Linux minutes at
  $0.006/min). Since 2026-03-01 self-hosted runners also draw from that quota in
  private repos.
- Google Jules (cloud coding agent): Free = 15 tasks per rolling 24h, 3 concurrent,
  beta, 18+. Capacity not guaranteed.
- GitHub Copilot Free: 2,000 completions/month, small undisclosed allowance for
  chat/agent. The Copilot cloud agent (assign issue -> PR) needs Pro ($10/mo).
- Linear Free: see table above.
- Model: your own Claude subscription (decided). Rate limits accepted for the PoC.
  Check Anthropic's current terms for using subscription auth through a
  third-party harness / headless 24/7 before leaving it running (unverified).

## 3. Where to host the teammate agent (Brazil-first)

The model is remote, so the host only runs the agent process, git, and your
tests. 2 GB RAM is probably enough to start, 4 GB is comfortable (unverified).

| Option | Cost | Region | Notes |
|---|---|---|---|
| Your own Arch machine / spare PC / Raspberry Pi | R$0 | local | Best first step. Add Tailscale for webhooks. Zero cost, no commitment. |
| Oracle Cloud Always Free (Ampere A1) | R$0 | Home region picked at signup, cannot move | Cut to 2 OCPU / 12 GB total (was 4/24; instances over the limit are terminated from 2026-08-18). 47 GB minimum boot volume. "Subject to capacity". Pay-As-You-Go accounts reportedly still keep 4/24 uncharged, a blog report, not Oracle documentation. |
| Magalu Cloud (SP, SE1) | BV1-1-10 (1 vCPU/1 GB): R$34,99/mo. BV2-4-10 (2 vCPU/4 GB): R$82,99/mo | Brazil | Billed PER SECOND, in BRL. Destroy it when idle: a weekend of testing costs a few reais. Best PoC value if you want a real Brazilian server. |
| Vultr São Paulo | $5 (1 GB), $10 (2 GB), $2.50 (0.5 GB) | São Paulo | USD billing, IOF applies. |
| AWS Lightsail São Paulo | from $5 (1 GB, 40 GB) | São Paulo | New AWS accounts get $100 + up to $100 credits for 6 months (verify credits apply to Lightsail). |
| Hostinger KVM 1 (1 vCPU/4 GB/50 GB) | R$29,99/mo promo | Brazil DC available | Promo is prepaid for 24 months (R$719,76) and renews at R$59,99/mo. Poor fit for a PoC. KVM 2: R$42,99 promo, renews R$77,99. |
| Google Cloud e2-micro | free | US only (us-west1/central1/east1) | 1 GB RAM, US latency; irrelevant since the model is remote, but tight on memory. |

Recommendation: (1) run it on your own machine until the loop works, (2) then
Magalu Cloud pay-per-second or Oracle Always Free to get 24/7, (3) skip Hostinger
unless you want a 2-year commitment.

## 4. Cost summary for the PoC

R$0 recurring: GitHub (public repo) + Actions + Telegram + Hermes (own machine)
+ your existing Claude subscription. Optional: Magalu VM, roughly R$35-85/month
if left running 24/7, much less if destroyed between sessions.
