# Smart Meal Planner & Nutrition Tracker

## Project Overview
The "Smart Meal Planner & Nutrition Tracker" is a production-ready, offline-first Flutter application designed for students and professionals. It allows users to plan daily meals, track calorie and macronutrient intake, monitor nutrition goals, and analyze eating habits. The app provides a premium, modern UI with smooth animations and functions fully offline by saving data locally and simulating syncing when an internet connection becomes available.

## Features
- **Meal Planner**: Plan daily meals for Breakfast, Lunch, Dinner, and Snacks.
- **Nutrition Tracking**: Track daily total calories, proteins, carbs, and fats consumed.
- **Offline-First Functionality**: All data is stored locally using Hive. The app queues unsynced data and synchronizes it automatically when online.
- **Goal Setting**: Set daily targets for calories, proteins, carbs, and fats.
- **Analytics Dashboard**: View weekly calorie trends, goal achievement percentages, and AI insights using beautiful fl_chart graphs.
- **Search & Filter**: Find logged meals instantly using real-time search and filter capabilities.
- **Premium UI**: Features a dynamic design with glassmorphism cards, animated progress indicators, and light/dark theme support.

## Tech Stack
- **Framework**: Flutter (latest stable)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Local Storage**: Hive (`hive`, `hive_flutter`)
- **Network Detection**: `connectivity_plus`
- **Charts/Analytics**: `fl_chart`
- **Date Formatting**: `intl`
- **Animations & UI**: `flutter_animate`, `google_fonts`, `shimmer`

## Folder Structure
```text
lib/
 ┣ core/
 ┃ ┣ constants/
 ┃ ┣ theme/
 ┃ ┣ utils/
 ┃ ┗ widgets/
 ┣ models/
 ┣ providers/
 ┣ repositories/
 ┣ screens/
 ┣ services/
 ┗ main.dart
```

## Setup Steps
1. **Clone the repository** (if applicable).
2. Ensure you have the **Flutter SDK** installed and running on the stable channel.
3. Open a terminal in the project directory.
4. Run `flutter pub get` to fetch all dependencies.
5. Run `flutter run` to launch the application on your preferred emulator or connected device.

## Future Scope
- **Barcode Scanner**: Integrate a barcode scanner to quickly fetch food nutrition data.
- **Cloud Database**: Implement Firebase or Supabase for real-time cloud synchronization and cross-device usage.
- **AI Meal Suggestions**: Suggest meals based on the user's available groceries and daily remaining calorie goals.
- **Water Tracking**: Add a dedicated module for tracking daily water intake.

## Conclusion
The Smart Meal Planner successfully demonstrates the usage of modern Flutter architecture, combining Riverpod for predictable state management and Hive for robust offline data persistence. The polished UI and robust offline capabilities make it an ideal presentation-ready application for a college practical or portfolio piece.
