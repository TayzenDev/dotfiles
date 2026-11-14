---
name: wt-run
description: Implement a wt spec unattended inside its git worktree - tests first, implementation, targeted then full tests (E2E included), simplify, fresh-context review, at most 3 fix rounds, then push and open the PR. Use only when the task prompt explicitly asks for the wt-run skill.
---

# wt-run: spec → PR, unattended

You run inside a git worktree created by `/wt`. The prompt that started this
session is the spec. The developer is not watching: don't ask questions,
decide with the spec's "Open points" defaults and record the decision. Never
run `workmux add` or create other worktrees.

## State

Keep everything in `.wt/` at the worktree root, untracked:

```bash
exclude="$(git rev-parse --git-common-dir)/info/exclude"
grep -qx '.wt/' "$exclude" 2>/dev/null || echo '.wt/' >> "$exclude"
```

- `.wt/spec.md`: the spec, copied verbatim from the prompt at the start.
- `.wt/state.md`: current step, test commands, review round, failures seen,
  decisions taken. Update it at the end of every step.

If `.wt/state.md` already exists, this is a resumed session: read it and
continue from the recorded step instead of starting over.

## 0. Setup

1. Gitignored env files are missing from a new worktree. For each `.env*`
   ignored file of the main worktree (first entry of
   `git worktree list --porcelain`, listed with
   `git -C <main> ls-files --others --ignored --exclude-standard`), copy it
   when it doesn't exist here. Never print
   their content.
2. Install dependencies with the repo's package manager (from its lockfile).
3. Find the test commands once and write them to `state.md`: read `CLAUDE.md`,
   `package.json` scripts, `justfile`/`Makefile`, `.github/workflows/`, git
   hooks. Note unit, typecheck/lint, full suite, E2E, and their prerequisites
   (emulator, local Supabase…).

## 1. Tests first

Write or update the tests listed in the spec. Run them: they must fail for
the expected reason (missing behavior, not a typo). Skip for pure refactors
or config changes the spec says aren't testable, and note why.

## 2. Implement

Follow the spec's approach and the patterns of the surrounding code. Stay
within the scope; anything from "Out of scope" or found along the way goes to
`state.md` under "Follow-ups", not into the diff. Commit when the targeted
tests pass, following the repo's commit conventions (look at `git log` and
its commit-msg hook).

## 3. Targeted tests

Run the tests covering the touched files, plus typecheck and lint. Fix until
green.

## 4. Full suite

Run all the tests, E2E included when the repo has them. E2E share an emulator
and local services between worktrees, so always run them under the repo-wide
lock (same for `git push` when a pre-push hook runs E2E):

```bash
lockf -t 3600 "$(git rev-parse --git-common-dir)/wt-e2e.lock" <e2e command>
```

Run long commands in the background and wait for their completion
notification. Have a subagent run noisy suites and report only the failures
(test, error, file:line) so your context stays clean.

## 5. Simplify

Once green, run the `simplify` skill on the branch diff, then rerun the
targeted tests.

## 6. Review in a fresh context

You don't review your own code. Commit, then in parallel:

- **Spec compliance**: spawn a `general-purpose` subagent with only this
  brief: read `.wt/spec.md` and `git diff origin/<base>...HEAD`; report, for
  each acceptance criterion, met or not with evidence, plus anything out of
  scope. Nothing else.
- **Correctness**: run the `code-review` skill at `high` on the branch.

Keep only **blocking** findings: unmet criteria, bugs, security issues,
broken tests. Note the rest in `state.md` for the PR description.

## 7. Fix loop

If there are blocking findings: fix them, then go back to step 3 (targeted
tests → full suite → review). Count rounds in `state.md`. Stop when:

- review has no blocking findings → **green**;
- 3 fix rounds are done, or the same failure comes back after a fix (no
  progress) → **unresolved**.

## 8. Rebase, push, PR

1. `git fetch origin <base>` then `git rebase origin/<base>`. On conflicts,
   look at `git log -p -n 3 origin/<base> -- <file>` first and keep both
   sides' intent. Rerun the targeted tests after a rebase that touched code.
2. Push with `git push -u origin HEAD` (under the lock above if the pre-push
   hook runs E2E). Never use `--no-verify` or any hook bypass; if the hook
   fails, treat it as a test failure in the loop.
3. Open the PR with `gh pr create --base <base> --title "<≤72 chars>" --body-file <file>`,
   adding `--draft` when **unresolved**. Body:

   ```markdown
   ## Summary
   <1-2 sentences: what and why, from the spec's Need>

   ## Changes
   - <key change>

   ## Testing
   - <suites run and result, E2E included>

   ## Remaining   (unresolved only)
   - <blocking findings left, failures, with what was tried>

   ## Follow-ups
   - <non-blocking review notes, out-of-scope ideas>
   ```

`<base>` is `git config --get branch.$(git branch --show-current).workmux-base`
without its `origin/` prefix, falling back to the default branch.

## End

Finish with a short message: PR link, green or draft, test results, and the
number of review rounds. That's what the developer sees when they open the
window.
