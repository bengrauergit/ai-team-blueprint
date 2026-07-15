export const meta = {
  name: 'build-loop',
  description: 'The builder builds a slice, tester verdicts against acceptance criteria, bounded at 5 passes',
  whenToUse:
    'For a groomed story with checkable acceptance criteria, when the main session wants the build→independent-UAT loop run to convergence or honest escalation. Pass args: {brief, criteria, architectureHeavy?}.',
  phases: [
    { title: 'Build', detail: 'builder implements, revising on tester feedback' },
    { title: 'Verify', detail: 'tester walks the acceptance criteria, schema verdict' },
  ],
}

// The canonical build loop (blueprint "Ralph loop", now in the REAL Workflow
// format: the blueprint's former sketch used an invented API and would not
// run). Exit = receipts or an honest escalation, never a soft "should work".
const MAX_PASSES = 5
// Tolerate args arriving as a JSON-encoded string: the harness can deliver
// the Workflow `args` parameter stringified rather than as an object (two
// live invocations bounced on this in production before the tolerance).
let parsedArgs = args
if (typeof parsedArgs === 'string') {
  try { parsedArgs = JSON.parse(parsedArgs) } catch { /* error below names the problem */ }
}
const { brief, criteria, architectureHeavy } = parsedArgs ?? {}
if (!brief || !criteria) {
  return { status: 'error', reason: 'args.brief and args.criteria are required. An ungroomed story never enters the loop' }
}

let feedback = null
for (let pass = 1; pass <= MAX_PASSES; pass++) {
  if (budget.total && budget.remaining() < 30_000) {
    return { status: 'escalate', reason: 'budget floor hit', pass, lastFailures: feedback }
  }

  await agent(
    [
      brief,
      `Completion criteria (checkable):\n${criteria}`,
      'TDD: encode the completion criteria as executable checks FIRST where the stack allows (check scripts, goldens, unit tests); show the relevant check failing before you implement (red before green), and ship the checks with the code.',
      feedback && `Previous UAT failures. Fix these specifically:\n${feedback}`,
    ].filter(Boolean).join('\n\n'),
    {
      agentType: 'builder',
      label: `build:pass${pass}`,
      phase: 'Build',
      // Pin the model EXPLICITLY. An omitted model inherits the SESSION
      // model, not the agent frontmatter; a loop launched from a cheap
      // session would silently build on the cheap tier (red-team finding).
      model: architectureHeavy === false ? 'sonnet' : 'opus',
    }
  )

  const verdict = await agent(
    `Independent UAT against these acceptance criteria (walk the degenerate cases too):\n${criteria}\n\nFIRST, on pass 1 only: if any criterion is not objectively checkable (no observable pass/fail), return done=false with failures naming each unverifiable criterion; an unverifiable criterion is a grooming defect, not a pass.`,
    {
      agentType: 'tester',
      label: `verify:pass${pass}`,
      phase: 'Verify',
      schema: {
        type: 'object',
        required: ['done', 'failures', 'receipts'],
        properties: {
          done: { type: 'boolean' },
          failures: { type: 'array', items: { type: 'string' } },
          receipts: { type: 'array', items: { type: 'string' } },
        },
      },
    }
  )

  if (verdict?.done) {
    return { status: 'done', passes: pass, receipts: verdict.receipts }
  }
  feedback = (verdict?.failures ?? ['tester returned no verdict']).join('\n')
  log(`pass ${pass}: not done. ${verdict?.failures?.length ?? '?'} failures`)
}

return {
  status: 'escalate',
  reason: `loop cap (${MAX_PASSES}) hit without convergence`,
  lastFailures: feedback, // the honest state, for the orchestrator
}
