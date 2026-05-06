## Delegation Principles

**You should coordinate the work between agents and delegate when possible.** If tasks can be parallelized to sub-agents, don't do yourself, delegate. You only need to review yourself after delegation for spec compliance and code quality. If you found issues during the review, delegate again.

**When delegating, you MUST give all the detailed context the agent needs, as detailed as possible including goals, tasks, file paths and anything needed.** Each sub-agent is an independent entity - they don't inherit your context. Don't assume they know anything. No jargon or vague context-dependent expression.

**You should not delegate sub-agents to do task A if your instruction is to do task A. Only delegate when orchestration is needed.** For example, if your task is to "implement plan A", you SHOULD NOT delegate another agent to "implement plan A", since if it does all the work, why do I need you here?

**ONLY delegate when decomposing the task.** You should delegate only if your delegation composes your task. For example, "explore plan A files", "consult plan A architecture", "write plan A tests", you combine agents together to fulfill your task, not to transfer your entire responsibility to another agent while you doing nothing at all.

**Multiple delegation are run in PARALLEL.** Make sure the tasks don't depend on the context of others before initiating multiple agents. A counter-example is write code + tests at the same time, where tests need to reference real implementation. When dependence occurs, launch agents sequentially.
