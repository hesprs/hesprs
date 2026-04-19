---
name: writing-plans
description: 'Mandatory workflow to transform vague ideas into validated designs and stepped implementation plans. Explores user intent, validates architecture incrementally in-context, and outputs a granular, code-free execution plan. Do NOT invoke implementation, write code, or scaffold until this process completes.'
---

## Core Mandate

Every feature request, regardless of perceived simplicity, must pass through this workflow. Shortcuts cause unexamined assumptions and wasted work. Keep the design and plan entirely in context (do not save to external files). Present the final validated plan directly in the chat.

## Sequential Workflow

### 1. Context Exploration

- Check the current project state: inspect files, docs, and recent commits.
- Identify existing patterns, architecture conventions, and potential integration points.
- Follow established conventions unless they directly block the new feature.

### 2. Scope Assessment & Decomposition

- Evaluate scope immediately after initial context gathering.
- If the request spans multiple independent subsystems, flag it and decompose into sub-projects. Define boundaries, dependencies, and build order.
- Proceed with this workflow for only **one sub-project at a time**. Each sub-project gets its own design validation → plan cycle + the final plan.

### 3. Clarifying Dialogue

- Ask **one question at a time** to refine purpose, constraints, and success criteria. Don't guess the user's intent.
- Prefer multiple-choice questions where possible; open-ended is acceptable when necessary.
- Only advance when the current question is answered. If a topic requires deeper exploration, break it into sequential questions.

### 4. Sectional Design & Validation

- Present the design in logical sections (e.g., Architecture, Core Components, Data Flow, Error Handling, Testing Strategy).
- Scale section depth to complexity (a few sentences for straightforward parts, more detail for nuanced logic).
- **Get explicit user approval after each section.** If the user requests changes, revise the section before proceeding.
- Design Principles:
  - **YAGNI ruthlessly:** Strip unnecessary features.
  - **Isolation & Boundaries:** Break systems into smaller units with single responsibilities and well-defined interfaces. Each unit must be independently testable and understandable.
  - **Interface Stability:** Ensure consumers can understand what a unit does without reading internals.
- Keep the evolving design entirely in-context. Do not write or commit spec files.

### 5. Plan Generation

- Once the design is fully approved section-by-section, generate the implementation plan.
- Structure the plan as a sequence of bite-sized tasks (each ~2–5 minutes of work).
- Use the exact Task Template below for every step.
- Save the plan as `<feature-name>.md` in `plans/` (create if not present).

### 6. Self-Review

- Run immediately after generating the full plan.
- Perform the Self-Review Protocol (see below).
- Fix logical gaps, ambiguities, or inconsistencies inline. No need to re-present unless changes alter core functionality.

---

## Plan Task Template

```markdown
### Task N: [Component/Feature Name]

**Files:**

- Create: `exact/path/to/new_file.ext`
- Modify: `exact/path/to/existing.ext` (specify relevant lines/sections if applicable)
- Test: `tests/exact/path/to/test_file.ext`

- [ ] **Step 1: Write failing test**
      Describe the test scenario, input data, assertions, and expected failure mode.

- [ ] **Step 2: Run test to verify failure**
      Command: `<exact command to run test>`
      Expected: FAIL with `[describe specific error/output]`

- [ ] **Step 3: Write minimal implementation**
      Describe the function/method signature, core logic, data transformations, and ideal implementation approach. Focus on what the code does and how it achieves it.

- [ ] **Step 4: Run test to verify pass**
      Command: `<exact command to run test>`
      Expected: PASS
```

---

## Self-Review Protocol

1. **Coverage Mapping:** Cross-reference every design requirement against the plan tasks. Identify and add any missing tasks.
2. **Placeholder & Ambiguity Scan:** Remove any `TBD`, `TODO`, `handle later`, or vague instructions. Every step must explicitly state what to do, where to do it, and what the expected outcome is.
3. **Logical & Signature Consistency:** Verify that types, function names, data structures, and file references remain consistent across all tasks. A signature defined in Task 2 must match its usage in Task 5.
4. **Code Fix Note:** Since this plan deliberately omits complete code blocks, do not attempt to "fix" code. Focus entirely on logical flow, implementation descriptions, and structural integrity.

---

## Key Principles

- **One thing at a time:** One clarifying question per message. One small step per plan task.
- **Incremental Validation:** Never proceed to the next design section or generate the plan without explicit user approval of the current section.
- **YAGNI & DRY:** Remove unnecessary features. Ensure shared logic is centralized, not duplicated across tasks.
- **TDD Discipline:** Every task follows the red-green-refactor cycle conceptually, even when describing implementation rather than writing it.
- **Context-Only Artifacts:** Designs and plans remain in the conversation context. Output the final plan directly when the workflow completes. Do not save to disk unless explicitly instructed otherwise.
- **No Implementation Until Approved:** Never write code, scaffold projects, or invoke implementation skills until the sectional design is approved and the plan is generated.
