---
name: write-plans
description: 'Mandatory workflow to transform vague ideas into validated designs and stepped implementation plans. Explores user intent, validates architecture incrementally in-context, and outputs a granular, code-free execution plan. Do NOT invoke implementation, write code, or scaffold until this process completes.'
---

## Core Mandate

Every feature request / refactor plan, regardless of perceived simplicity, must pass through this workflow. Shortcuts cause unexamined assumptions and wasted work. Save the final validated plan in `plans/<feature-name>.md` (create if not present). Do not edit code.

## Sequential Workflow

### 1. Context Exploration

- Check the current project state: inspect files, docs, and recent commits.
- Identify existing patterns, architecture conventions, and potential integration points.
- Follow established conventions unless they directly block the new feature.

### 2. Scope Assessment & Decomposition

- Evaluate scope immediately after initial context gathering.
- If the request spans multiple independent subsystems, flag it and decompose into sub-projects. Define boundaries, dependencies, and build order.
- Proceed with this workflow for only **one sub-project at a time**. Each sub-project gets its own design validation → plan cycle + the distinct plan Markdown saved in `plans/`.

### 3. Clarifying Dialogue

- Deep dive into the implementation of the described feature / refactor, discover every un-described decision that makes difference. Ask the human for clarification.
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
- Must include:
  - context (why should we do this)
  - current implementation
  - target implementation
  - files related and what to change / not change (**you MUST inspect source files and point to specific file paths and what to change in detail**)
  - testing

### 6. Self-Review

- Run immediately after generating the full plan.
- Perform the Self-Review Protocol (see below).
- Fix logical gaps, ambiguities, or inconsistencies inline. No need to re-present unless changes alter core functionality.

## Self-Review Protocol

1. **Coverage Mapping**: Cross-reference every design requirement against the plan tasks. Identify and add any missing tasks.
2. **Placeholder & Ambiguity Scan**: Remove any `TBD`, `TODO`, `handle later`, or vague instructions. Every change must explicitly state what to do, where to do it, and what the expected outcome is.
3. **Logical & Signature Consistency**: Verify that types, function names, data structures, and file references remain consistent across all tasks. A signature defined in Task 2 must match its usage in Task 5.
4. **Zero-Knowledge Readability**: Act as an engineer that does not know this at all, can you understand what the plan is describing and immediately find the correct files & make the desired changes? Have you given readers enough context? If not, include more context.
5. **Specificity**: Have you explicitly written specific files and what to change in detail in the plans?

---

## Key Principles

- **One thing at a time**: One clarifying question per message. One small step per plan task.
- **Incremental Validation**: Never proceed to the next design section or generate the plan without explicit user approval of the current section.
- **YAGNI & DRY**: Remove unnecessary features. Ensure shared logic is centralized, not duplicated across tasks. No need for backward compatibility or legacy support, remove everything redundant immediately during the refactor.
- **No Implementation Until Approved**: Never write code, scaffold projects, or invoke implementation skills until the sectional design is approved and the plan is generated.
- **No Hesitation**: the plan should be deterministic; don't use "prefer", "consider", "may ... later".
- **Maintainable**: the plan should maximize future maintainability.
