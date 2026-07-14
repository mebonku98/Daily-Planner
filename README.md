# Daily Planner

A native SwiftUI iOS 17 app for coordinating a practical family routine across work, childcare, home life, movement, and creative time.

## Family Week MVP

- Coordinated weekday and weekend plans for Mum, Dad, and shared family time
- Family-member filters and visible responsibility ownership
- Editable activities with schedule, owner, category, notes, and start/end times
- Add, delete, and reorder controls
- Double-booking warnings, including shared activities that require both parents
- Interactive daily checklist with on-device persistence
- Time-allocation chart for the selected schedule
- Accessible labels, hints, controls, and Dynamic Type-compatible layouts

The starter templates reflect the family's current rhythm:

- Dad handles school/daycare drop-off and pickup, lunchboxes, and dinner preparation
- Mum has a seven-hour iOS workday with commute time
- Bath, study, bedtime, family meals, exercise, gardening, embroidery, sewing, home planning, cycling, and swimming all have protected space

## Requirements

- Xcode 15.3 or later
- iOS 17 or later
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Open the project

```sh
brew install xcodegen
xcodegen generate
open DailyPlanner.xcodeproj
```

`project.yml` is the source of truth for the generated Xcode project. The generated `.xcodeproj` is intentionally not committed.

## Architecture

- `FamilyRoutine` supplies safe weekday and weekend templates.
- `RoutineStore` owns editing, filtering, completion state, and JSON persistence in `UserDefaults`.
- `ScheduleValidator` reports overlapping commitments for each parent.
- SwiftUI views render the family timeline and activity editor.
- Unit tests cover persistence, validation, filtering, invalid input, and template integrity.

## Roadmap

1. Calendar-based day selection and recurring weekly patterns
2. Local notifications and calendar export
3. Optional iCloud family sync
4. Widgets and Live Activities
5. Seasonal and school-holiday template packs
