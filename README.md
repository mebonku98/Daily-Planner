# Daily Planner

A native SwiftUI iOS app for visualising and completing a balanced daily routine across work, family care, and personal time.

## First release

- Winter weekday routine beginning at 7:30 AM
- Start/end times and duration for every activity
- Interactive checklist with progress saved on-device
- Daily time-allocation donut chart
- Filters for morning, work, family, and personal activities

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

`project.yml` is the source of truth for the generated Xcode project.

## Roadmap

1. Edit and reorder routine activities
2. Weekday, weekend, summer, and school-holiday schedules
3. Coordinated family views
4. Calendar export and reminders
5. Optional iCloud sync
