<!--
Sync Impact Report
Version change: template -> 1.0.0
Modified principles:
- Principle 1 placeholder -> I. Family Routine First
- Principle 2 placeholder -> II. Native SwiftUI and XcodeGen Source of Truth
- Principle 3 placeholder -> III. On-Device Privacy for MVP
- Principle 4 placeholder -> IV. Accessibility and Calm Visual Design
- Principle 5 placeholder -> V. Small, Testable, CI-Backed Changes
Added sections:
- Product and Platform Constraints
- Development Workflow
Removed sections:
- None
Templates requiring updates:
- Updated: .specify/templates/plan-template.md
- Updated: .specify/templates/spec-template.md
- Updated: .specify/templates/tasks-template.md
Runtime guidance reviewed:
- README.md
- docs/MVP_SPECIFICATION.md
- .agents/skills/speckit-*.md
Follow-up TODOs:
- None
-->
# Daily Planner Constitution

## Core Principles

### I. Family Routine First
Daily Planner MUST protect a practical family schedule across work, childcare,
exercise, creative practice, home planning, and family time. Every feature MUST make
ownership, timing, or daily feasibility clearer for the family. Features that add
planning overhead without improving those outcomes MUST be rejected or deferred.

Rationale: The product exists to make the family day workable, not to become a
general-purpose productivity system.

### II. Native SwiftUI and XcodeGen Source of Truth
The app MUST remain a native SwiftUI iOS 17+ application. `project.yml` is the
source of truth for project structure, targets, dependencies, and generated Xcode
settings. Generated `.xcodeproj`, `Products/`, DerivedData, or duplicate app setup
artifacts MUST NOT be committed. New files, targets, or package dependencies MUST be
represented through XcodeGen when project structure changes.

Rationale: A single reproducible project definition keeps GitHub review focused on
source changes and prevents drift between generated Xcode state and committed source.

### III. On-Device Privacy for MVP
MVP family schedule data MUST remain on-device. The app MUST NOT introduce backend
services, analytics, tracking SDKs, accounts, cloud sync, or network-required launch
behavior without an explicit constitutional amendment or a post-MVP specification that
revisits this privacy boundary. Local persistence MUST avoid stale or duplicate routine
state.

Rationale: Family schedules are sensitive, and the MVP can deliver value without a
server-side data model.

### IV. Accessibility and Calm Visual Design
User-facing features MUST support Dynamic Type, VoiceOver labels and hints for
important controls, and meaning that is not conveyed by color alone. Visual design MUST
stay calm, legible, and routine-focused: dense enough for family planning, restrained in
decoration, and clear about time, ownership, completion, and conflicts.

Rationale: The app is used during busy family routines, so it must remain readable,
predictable, and accessible under real-world conditions.

### V. Small, Testable, CI-Backed Changes
Changes MUST be scoped to the requested behavior and existing SwiftUI/store/model
boundaries. Behavior changes MUST include focused tests or a documented validation path.
Store and model logic MUST prefer Swift Testing unit coverage; user-facing flows SHOULD
add XCUIAutomation coverage when the interaction risk is meaningful. GitHub Actions
build and test status MUST remain the confidence gate before merge.

Rationale: Small verified increments keep the family planner reliable while the routine
model evolves.

## Product and Platform Constraints

- The MVP MUST support weekday and weekend family routines for Mum, Dad, and Together
  responsibilities.
- The MVP MUST preserve local-first behavior using on-device persistence.
- The app MUST launch without network access and provide default routine content on first
  launch.
- Schedule conflict detection MUST account for shared activities requiring both parents.
- New dependencies MUST be justified in the implementation plan and kept minimal.
- App behavior MUST align with the README and MVP specification unless those documents
  are intentionally updated in the same change.

## Development Workflow

- GitHub is the source of truth for review, CI status, and merge readiness.
- Feature specifications MUST state user value, privacy boundaries, accessibility
  expectations, and measurable success criteria before planning.
- Implementation plans MUST pass the Constitution Check before research and again after
  design.
- Task lists MUST be organized as independently testable user-story increments with exact
  file paths.
- Project structure changes MUST update `project.yml`; generated project files MUST remain
  untracked.
- Pull requests MUST include or reference validation evidence: tests, build results,
  accessibility checks, or documented manual verification.

## Governance

This constitution supersedes conflicting project guidance. Amendments MUST be proposed as
documented changes to `.specify/memory/constitution.md`, include a Sync Impact Report,
and update dependent templates or runtime guidance in the same change when affected.

Versioning follows semantic versioning:

- MAJOR: Remove or redefine a core principle or privacy/platform boundary.
- MINOR: Add a new principle, governance section, or materially expanded mandatory gate.
- PATCH: Clarify wording, fix typos, or make non-semantic refinements.

Compliance review is required during specification, planning, task generation, code
review, and CI validation. If a feature cannot satisfy a MUST-level principle, the
feature MUST stop until the plan is changed or this constitution is amended.

**Version**: 1.0.0 | **Ratified**: 2026-07-22 | **Last Amended**: 2026-07-22
