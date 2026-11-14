---
name: wt
description: Grill the developer about a dev task until the need and the approach are clear, write a self-contained spec, then launch it in a new git worktree and branch with workmux, where the wt-run skill implements, tests, reviews and opens the PR.
argument-hint: "<task description, issue link or spec file>"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(git fetch:*), Bash(git symbolic-ref:*), Bash(git branch:*), Bash(workmux add:*), Bash(mktemp:*)
---

# wt: grill, spec, dispatch

Task: $ARGUMENTS

This skill runs in the developer's current session and has three phases: grill,
spec, dispatch. It never implements anything. The worktree agent does that,
unattended, with the `wt-run` skill, so everything it needs must be in the spec.

## 1. Grill

Follow [references/grill.md](references/grill.md). In short: one question at a
time, each with your recommended answer, and never ask what the codebase can
answer. Explore the code (read, grep) as much as the questions need, but write
nothing.

Stop when every section of the spec below can be filled without guessing.

## 2. Spec

Write the spec to a temp file (`mktemp -t wt-spec`, then rename to `.md`) using
this template. Repo-relative paths only (the worktree has its own root);
attachments outside the repo (screenshots…) keep their absolute path.

```markdown
Use the wt-run skill to implement the spec below.

# <Title>

## Need
<Who has the problem, what it is, why it matters now. 2-5 lines.>

## Approach
<The solution agreed during the grill: files/modules to touch, data flow,
patterns to follow (with paths to existing examples), decisions taken and why.>

## Acceptance criteria
- [ ] <Observable behavior, testable>

## Tests
- <Tests to write or update (unit / integration / E2E), with the scenario each covers>

## Out of scope
- <What not to do, even if tempting: refactors, neighbor features, polish>

## Open points
- <Anything left to the implementer's judgment, with the preferred default>
```

Show the spec to the developer and ask for an explicit go. Apply their changes
and ask again until they approve. No go, no dispatch.

## 3. Dispatch

1. Pick a branch name: 2-4 words, kebab-case, prefixed with the repo's
   convention when it has one (look at `git branch -r`), e.g. `feat/capture-search`.
   Propose it with the spec so the developer can change it.
2. Find the default branch (`git symbolic-ref --short refs/remotes/origin/HEAD`,
   fallback `main`) and fetch it: `git fetch origin <default>`.
3. Launch, from the current directory:

   ```bash
   workmux add <branch> -b -P <spec-file> --base origin/<default>
   ```

   If the developer asked to stack on the current branch, drop `--base`.
4. Reply with the branch name and one line: the agent works in the background
   in its own tmux window and ends with a PR link (or a draft PR listing what
   is left).

Do not follow up on the agent yourself unless asked; `workmux-status:coordinator`
does that when several `/wt` run in parallel.
