# HabitUp - Flutter App Development Plan

## Tech Stack
- **Framework:** Flutter 3.x (iOS + Android)
- **State Management:** Riverpod
- **Local Database:** Hive (lightweight, fast)
- **Ads:** Google AdMob (Banner + Interstitial)
- **Charts:** fl_chart
- **Notifications:** flutter_local_notifications
- **Widgets:** home_widget (iOS/Android home screen widgets)

---

## Project Structure

```
lib/
├── main.dart
├── app.dart
│
├── config/
│   ├── theme.dart              # Pink/Green theme
│   ├── routes.dart
│   └── admob_config.dart       # AdMob IDs
│
├── models/
│   ├── habit.dart              # Habit model
│   ├── habit_record.dart       # Daily record
│   └── enums/
│       ├── habit_type.dart     # boolean, quantity, count, duration
│       └── frequency.dart      # daily, weekly, custom days
│
├── providers/
│   ├── habit_provider.dart
│   ├── record_provider.dart
│   ├── stats_provider.dart
│   └── ad_provider.dart
│
├── services/
│   ├── database_service.dart   # Hive CRUD
│   ├── notification_service.dart
│   ├── ad_service.dart         # AdMob manager
│   └── widget_service.dart     # Home screen widgets
│
├── screens/
│   ├── home/
│   │   ├── home_screen.dart          # Main daily view
│   │   ├── widgets/
│   │   │   ├── date_ribbon.dart      # Date picker strip
│   │   │   ├── habit_card.dart       # Each habit row
│   │   │   ├── habit_progress.dart   # Progress bar
│   │   │   └── filter_chip.dart      # ALL filter
│   │
│   ├── report/
│   │   ├── report_screen.dart        # Weekly/Monthly/Yearly
│   │   ├── widgets/
│   │   │   ├── dot_matrix.dart       # Color dot grid
│   │   │   ├── stats_summary.dart    # Met%, BestDay, etc.
│   │   │   └── share_card.dart       # Shareable image
│   │
│   ├── habit_detail/
│   │   ├── detail_screen.dart        # Per-habit tracking
│   │   ├── widgets/
│   │   │   ├── calendar_heatmap.dart # Monthly calendar view
│   │   │   ├── yearly_heatmap.dart   # Yearly grid
│   │   │   └── record_stats.dart     # Days, Streak cards
│   │
│   ├── create_habit/
│   │   ├── create_screen.dart        # Add/Edit habit
│   │   └── widgets/
│   │       ├── icon_picker.dart
│   │       ├── color_picker.dart
│   │       └── goal_setting.dart     # Type, target, unit
│   │
│   └── settings/
│       └── settings_screen.dart
│
├── widgets/
│   ├── banner_ad_widget.dart         # AdMob banner
│   └── bottom_nav_bar.dart           # 5-tab navigation
│
└── utils/
    ├── date_utils.dart
    ├── streak_calculator.dart
    └── export_utils.dart             # Share as image
```

---

## Data Models

### Habit
| Field         | Type     | Description                    |
|---------------|----------|--------------------------------|
| id            | String   | UUID                           |
| name          | String   | "Drink water", "Yoga"          |
| icon          | String   | Icon code                      |
| color         | int      | Habit color (hex)              |
| type          | HabitType| boolean/quantity/count/duration |
| targetValue   | double   | Goal (3000ml, 30min, 1 time)   |
| unit          | String   | "ml", "m", "times"            |
| frequency     | List<int>| Days of week [1,2,3,4,5,6,7]  |
| reminderTime  | String?  | Notification time              |
| createdAt     | DateTime |                                |
| sortOrder     | int      | Display order                  |

### HabitRecord
| Field       | Type     | Description              |
|-------------|----------|--------------------------|
| id          | String   | UUID                     |
| habitId     | String   | FK to Habit              |
| date        | DateTime | Record date              |
| value       | double   | Actual value achieved    |
| isCompleted | bool     | Met the target?          |

---

## Screens & Features (Phase Plan)

### Phase 1: Core (Week 1-2)
1. **Project setup** - Flutter init, dependencies, theme
2. **Database** - Hive setup, models, CRUD
3. **Home Screen** - Date ribbon, habit list, progress tracking
4. **Create/Edit Habit** - Form with icon/color picker, goal setting
5. **Daily Tracking** - Tap to complete, long press to edit value

### Phase 2: Reports & Stats (Week 3)
6. **Habit Detail Screen** - Calendar heatmap, yearly grid, streak stats
7. **Report Screen** - Dot matrix, Weekly/Monthly/Yearly tabs
8. **Stats Calculation** - Met%, BestDay, TotalDone, BestStreak
9. **Share Report** - Export report card as image

### Phase 3: AdMob Integration (Week 4)
10. **Banner Ads** - Bottom of home screen, report screen
11. **Interstitial Ads** - After creating habit, between screen transitions
12. **Ad Frequency Control** - Don't show too often (every 3-5 actions)

### Phase 4: Polish (Week 5)
13. **Notifications** - Daily reminders per habit
14. **Home Screen Widgets** - iOS/Android widgets showing today's habits
15. **Onboarding** - First-time user flow with suggested habits
16. **Dark Mode** - Theme toggle

---

## AdMob Strategy

```
┌─────────────────────────────────┐
│         Home Screen             │
│  ┌───────────────────────────┐  │
│  │  Habit List (scrollable)  │  │
│  │  ...                      │  │
│  │  ...                      │  │
│  └───────────────────────────┘  │
│  ┌───────────────────────────┐  │
│  │   Banner Ad (320x50)      │  │  ← Fixed bottom banner
│  └───────────────────────────┘  │
│  ┌───────────────────────────┐  │
│  │   Bottom Navigation       │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

- **Banner Ad:** Home screen bottom, Report screen bottom
- **Interstitial Ad:** Show after every 3rd habit creation or 5th report view
- **Rewarded Ad (optional):** Unlock premium themes/icons

---

## Key Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  google_mobile_ads: ^5.1.0
  fl_chart: ^0.68.0
  flutter_local_notifications: ^17.0.0
  home_widget: ^0.6.0
  uuid: ^4.2.1
  intl: ^0.19.0
  share_plus: ^9.0.0
  screenshot: ^3.0.0
  path_provider: ^2.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.8
```

---

## Color Theme (from screenshots)

```dart
// Primary palette
Color primaryPink    = Color(0xFFF5B7B1);  // Soft pink header
Color primaryGreen   = Color(0xFFD5F5E3);  // Soft green background
Color accentRed      = Color(0xFFE74C3C);  // Stats highlight
Color accentBlue     = Color(0xFF5DADE2);  // Progress bar (water)
Color accentOrange   = Color(0xFFF5B041);  // Progress bar (stand)
Color backgroundWhite= Color(0xFFFDFDFD);  // Card background
```
