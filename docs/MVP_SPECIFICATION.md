# Daily Planner MVP Specification

## Summary

Daily Planner is a native SwiftUI iOS app that helps a family coordinate a practical weekly rhythm across work, school, daycare, home care, movement, creative time, and family connection.

The MVP is the Family Week Planner: a visual, editable schedule for weekdays and weekends that makes ownership visible, protects important personal routines, and warns when the plan double-books a parent.

## Product Goal

Create a simple, sustainable planning tool that helps the family see whether the day works before the day begins.

The MVP should answer three questions quickly:

- What is happening today?
- Who is responsible for each moment?
- Does the schedule leave protected space for work, childcare, exercise, creative practice, home planning, and rest?

## Target Users

### Primary user: Mum

Mum is returning to balanced iOS work while protecting time for embroidery, sewing, new-home planning, cycling, swimming, children's bath and study routines, and family time.

She needs the app to make the day feel workable instead of abstract. The plan should help her see work commitments, family routines, and personal recovery time in one place.

### Secondary user: Dad

Dad is a senior business analyst who handles school and daycare drop-off and pickup, lunchbox and dinner preparation, exercise, and gardening.

He needs the app to show ownership clearly so family logistics are visible and adjustable without repeated negotiation.

## MVP Scope

The MVP includes:

- Weekday and weekend routine templates
- Ownership for Mum, Dad, and Together activities
- Category labels for morning, work and travel, family care, and personal time
- Timeline-style routine list sorted by start time
- Interactive completion checklist
- Local persistence for edited routines and completed items
- Add, edit, delete, and reorder actions
- Family-member filters
- Time-allocation chart
- Double-booking warnings for individual and shared commitments
- Basic accessibility support for labels, hints, and Dynamic Type-friendly layouts
- Unit tests for store behavior, validation, filtering, persistence, and template integrity
- GitHub Actions build and test workflow

## Out of Scope

The MVP does not include:

- User accounts or authentication
- Cloud sync
- Shared multi-device editing
- Calendar import or export
- Push or local notifications
- Widgets or Live Activities
- School-holiday template packs
- Analytics
- App Store packaging
- Backend services

These are roadmap items after the base family-planning loop is proven useful.

## Core User Flows

### View the family plan

The user opens the app and sees the current selected routine, progress, ownership, and time allocation.

Acceptance criteria:

- The app shows a weekday routine by default.
- The user can switch between weekday and weekend.
- Each activity shows start time, end time, title, notes, owner, category, and duration.
- Shared activities are clearly marked as Together.

### Filter by family member

The user filters the routine to see Mum, Dad, or Together responsibilities.

Acceptance criteria:

- Everyone shows all activities.
- Mum shows Mum and Together activities.
- Dad shows Dad and Together activities.
- Together shows shared activities.
- Switching schedule resets the active family-member filter.

### Complete routine moments

The user marks activities complete throughout the day.

Acceptance criteria:

- Tapping an activity checklist control toggles completion.
- Completed state is visually distinct.
- Progress count updates immediately.
- Completion state persists after app restart.
- The user can reset completion for the selected schedule.

### Edit the plan

The user adjusts an existing activity or creates a new activity.

Acceptance criteria:

- The user can add a new activity from the toolbar.
- The user can edit title, notes, category, schedule, owner, start time, and end time.
- Title is required.
- End time must be later than start time.
- Valid changes persist after app restart.

### Rebalance the day

The user moves, deletes, or restores activities when the schedule changes.

Acceptance criteria:

- The user can delete an activity.
- Deleting an activity removes its completion state.
- The user can move owned activities earlier or later within the same schedule and owner group.
- The user can restore the original family templates.

### Notice conflicts

The user sees a warning when a parent is double-booked.

Acceptance criteria:

- Overlapping Mum-owned activities create a Mum conflict.
- Overlapping Dad-owned activities create a Dad conflict.
- Shared activities are treated as requiring both parents.
- Invalid zero-length or negative-length activities are ignored by conflict validation.
- Conflict messages name the affected parent and activities.

## Data Model

### RoutineItem

Represents one scheduled activity.

Fields:

- `id`: Stable unique identifier
- `schedule`: Weekday or weekend
- `owner`: Mum, Dad, or Together
- `startMinutes`: Start time as minutes after midnight
- `endMinutes`: End time as minutes after midnight
- `title`: Activity name
- `note`: Supporting detail
- `category`: Morning, work and travel, family care, or personal

### FamilyMember

Represents ownership:

- Mum
- Dad
- Together

### ScheduleKind

Represents the selected template:

- Weekday
- Weekend

### Persistence

The MVP stores data on-device in `UserDefaults`:

- Routine items are JSON-encoded.
- Completion is stored as a set of item IDs.
- Completion IDs are intersected with current routine item IDs on load to avoid stale references.

## Default Routine Content

The weekday template must protect:

- Dad's morning exercise
- Shared breakfast
- Dad's school and daycare drop-off
- Mum's work preparation and commute
- Mum's seven-hour iOS workday with lunch/reset time
- Dad's business analysis work block
- Dad's school and daycare pickup
- Children's bath time
- Study and reading
- Dad's dinner preparation
- Family dinner
- Children's bedtime
- Mum's creative practice
- Dad's garden/reset time
- Shared evening wind down

The weekend template must protect:

- Slow shared breakfast
- Dad's gardening
- Mum's embroidery or sewing
- Family cycling or swimming
- Shared lunch
- Mum's new-home planning
- Dad's exercise
- Family free time
- Dad's dinner preparation
- Shared dinner and bedtime

## Non-Functional Requirements

### Platform

- Native SwiftUI app
- iOS 17 or later
- Xcode project generated from XcodeGen
- Clean Architecture boundaries for domain rules, app state, infrastructure, and SwiftUI presentation
- No backend required

### Reliability

- The app must launch without network access.
- Default templates must be available on first launch.
- User edits must survive app relaunch.
- Restore templates must return the app to a known-good routine.

### Accessibility

- Important controls must have accessibility labels.
- Layouts should work with Dynamic Type.
- Color should support meaning but not be the only source of meaning.

### Privacy

- MVP data remains on-device.
- No family schedule data is transmitted externally.
- No analytics or tracking are included.

## Definition of Done

The Family Week MVP is done when:

- The app builds for iOS 17.
- Unit tests pass.
- GitHub Actions build and test workflow passes.
- The user can view, filter, complete, edit, add, delete, move, reset, and restore family routine items.
- Schedule conflicts are visible and accurate.
- The README explains how to generate and open the Xcode project.
- This specification and the roadmap agree on what is in and out of MVP scope.

## Post-MVP Milestones

Recommended next milestones:

1. Calendar-based day selection and recurring weekly patterns
2. Local notifications and calendar export
3. Optional iCloud family sync
4. Widgets and Live Activities
5. Seasonal and school-holiday template packs

The next highest-value milestone is calendar-based day selection because it turns the MVP from two static templates into a usable week-planning habit.
