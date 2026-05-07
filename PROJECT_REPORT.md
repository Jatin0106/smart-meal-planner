# Smart Meal Planner & Nutrition Tracker - Final Report

## 1. Introduction
The Smart Meal Planner & Nutrition Tracker is a mobile application developed using Flutter. It aims to solve the problem of maintaining a healthy diet by providing users with an intuitive interface to plan meals, log food entries, and track their macronutrient intake efficiently.

## 2. Problem Statement
Maintaining a balanced diet is challenging for students and working professionals due to busy schedules. Existing apps often require a constant internet connection, lack a user-friendly interface, or have overwhelming features that complicate simple daily tracking. There is a need for an offline-first, aesthetically pleasing, and straightforward application to log meals and track calories.

## 3. Objectives
- Develop a premium and responsive UI that is easy to navigate.
- Implement robust offline functionality using a local database so users can track meals without the internet.
- Calculate and display real-time daily nutritional progress.
- Provide insightful analytics and charts for users to visualize their eating habits over time.

## 4. Modules
- **Meal Planning Module**: Allows users to group and view meals based on categories (Breakfast, Lunch, Dinner, Snacks).
- **Food Entry Module**: Contains a searchable database of foods. Users can add custom foods or select existing ones to compute total calories and macros dynamically based on serving size.
- **Nutrition Tracking Module**: A dashboard that visualizes daily targets versus actual consumption using circular and linear progress indicators.
- **Analytics Dashboard Module**: Visualizes weekly consistency and caloric goals using bar charts.
- **Search & Filter Module**: Enables users to search their historical meal logs and filter them by category.
- **Offline Sync Module**: Queues offline actions and marks data as "synced" once the network connection is restored.

## 5. Working Explanation
The app uses Riverpod as the central state management solution, injecting Hive repository instances to read and write data seamlessly. When a user logs a meal in the `FoodEntryScreen`, the `MealRepository` calculates the updated daily macro sums and persists them. The `TrackingScreen` and `MealPlannerScreen` listen to these state changes and update the UI implicitly. The `SyncService` operates by checking the local `isSynced` flag of meal models, mimicking an API push when internet connectivity is simulated.

## 6. Screens Description
- **Main Screen**: Holds the bottom navigation bar and coordinates switching between core screens using an `IndexedStack`.
- **Meal Planner Screen**: Displays the daily logged meals grouped by type. Includes swipe-to-delete functionality.
- **Food Entry Screen**: Presents a search bar, a list of default foods, and an intuitive bottom sheet modal for quantity input.
- **Tracking Screen**: Showcases beautiful circular progress indicators for calories and linear progress bars for Proteins, Carbs, and Fats.
- **Analytics Screen**: Features an interactive bar chart visualizing the last 7 days of calorie intake against the set goal.

## 7. Future Scope
- Barcode scanning functionality for packaged foods.
- Cloud integration (e.g., Firebase) to sync data across multiple devices.
- Integration with smartwatches (HealthKit / Google Fit).

## 8. Conclusion
The Smart Meal Planner application successfully fulfills its objectives of offering an offline-first, premium user experience for nutrition tracking. The modular architecture and usage of Riverpod and Hive make it a highly scalable and robust solution, perfect for modern mobile app standards.
