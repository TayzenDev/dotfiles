# Grilling the developer

Goal: a shared understanding of the need and of the solution, deep enough that
an agent can implement it alone without coming back with questions.

## Rules

- **One question at a time.** Wait for the answer before the next one; the
  answer often changes what to ask next.
- **Always give your recommended answer** and why in one line. Use
  `AskUserQuestion` when the choices are discrete (recommended option first,
  labelled "(Recommended)"); plain text when the answer is open.
- **Never ask what the code can answer.** Before asking "where is X handled?"
  or "is there already a helper for Y?", look. Ask only about intent, priorities
  and trade-offs, and quote what you found ("`packages/core/src/sync.ts` already
  retries 3 times; keep that?").
- **Walk the decision tree.** Resolve the decisions others depend on first
  (scope, data model) before the ones that follow (UI, naming). Don't open a
  new branch while one is unresolved.
- **Challenge, don't agree.** Point out simpler alternatives, hidden costs,
  edge cases and conflicts with existing code. The developer may still choose
  their way; record it.
- **Stop when it's enough.** A small fix needs two or three questions, a
  feature maybe ten. Don't ask for the sake of the checklist.

## What to cover

Skip what the task or the code already settles.

1. **Need**: the problem from the user's point of view, the trigger, what
   "done" looks like. Is there a simpler need behind the stated solution?
2. **Scope**: what's in, what's explicitly out. The smallest version that
   solves the need.
3. **Approach**: how the developer sees the implementation. Compare with the
   existing patterns in the codebase; propose an alternative when one is
   clearly simpler.
4. **Data and contracts**: schema or migration changes, API shape, backward
   compatibility, what existing data becomes.
5. **Edge cases and errors**: empty, offline, concurrent, permissions, large
   inputs, failures of external services.
6. **Tests**: which behaviors prove it works, at which level (unit,
   integration, E2E). Which existing tests will change.
7. **Risks**: security, performance, anything touching production
   environments or user data.

End by summarising the decisions in a few bullets before writing the spec.
