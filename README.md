# Hydration Reminder iOS App

A smart hydration tracker built with SwiftUI and Core Data.

## Features

- Set a daily goal based on weight and activity level
- Log water with customizable cup sizes and drink types
- Smart reminders when you haven’t logged in a while (and after workout)
- Track caffeine across coffee, tea, soda, etc.

## Project Structure

```
NotesApp/
  HydrationReminderApp.swift  # App entry, notifications
  ContentView.swift           # TabView with Today/History/Settings
  TodayView.swift             # Progress + quick add + add drink
  HistoryView.swift           # List of logged drinks
  SettingsView.swift          # Weight, activity, cup sizes, goal
  HydrationHelpers.swift      # Goal calc, settings, stats, log helper
  NotificationManager.swift   # Local notification scheduling
  PersistenceController.swift # Core Data stack
  NotesModel.xcdatamodeld/    # Core Data model
  Assets.xcassets/            # App icons and assets
```

## Core Data Model

- HydrationEntry: `amountMl:Int64`, `timestamp:Date`, `drinkType:String?`, `caffeineMg:Int64?`, `source:String?`
- UserSettings: `weightKg:Double?`, `activityLevel:String?`, `dailyGoalMl:Int64?`, `cupSizes:String?`, `lastWorkout:Date?`

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.0+

## Build & Run

1. Open `NotesApp.xcodeproj` in Xcode
2. Select a simulator or device
3. Run

The app requests notification permission on first launch to enable smart reminders.

## Notes

This project was migrated from a simple notes app to a hydration tracker. Legacy note screens are stubs and no longer used.

