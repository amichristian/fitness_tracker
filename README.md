# Fitness Tracker

A Flutter-based mobile application for managing workouts and tracking fitness progress.

## Project Information

**Project Name:** Fitness Tracker
**Student:** Ami Christian
**Student ID:** 2401000232
**Platform:** Flutter
**Backend:** Firebase
**Database:** Cloud Firestore
**Authentication:** Firebase Authentication
**Storage:** Firebase Cloud Storage
**Advertisements:** Google Mobile Ads

## Overview

Fitness Tracker is a mobile application developed with Flutter to help users organize and manage their fitness activities.

The application allows authenticated users to create and manage workout records. It also provides a structure for exercises and progress logs so that fitness information can be organized in one application.

## Main Features

* User registration and sign-in
* Firebase authentication
* Authentication gate for protected screens
* Workout creation
* Workout viewing
* Workout editing
* Workout deletion
* Workout details
* Exercise management structure
* Progress log management structure
* Firebase Cloud Firestore database
* Firebase Cloud Storage integration
* Advertisement integration
* Banner advertisement
* Interstitial advertisement after completing a new workout
* User-owned Firestore data
* Error handling for application operations

## Technologies Used

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Firebase Cloud Storage
* Google Mobile Ads
* Material Design

## Application Architecture

The application follows a simple Flutter structure that separates screens, models, services, and reusable widgets.

```text
lib/
├── models/
├── screens/
├── services/
├── widgets/
├── firebase_options.dart
└── main.dart
```

### Main Components

**Models**
Represent the application's data such as workouts, exercises, and progress logs.

**Screens**
Contain the user interface for authentication, home pages, workout management, and other application functions.

**Services**
Handle communication between the Flutter application and Firebase services.

**Widgets**
Contain reusable interface components such as advertisement widgets and other UI elements.

## Data Model

The application is designed around four main entities:

1. User
2. Workout
3. Exercise
4. ProgressLog

### Relationships

* A user can have multiple workouts.
* A workout can contain exercise information.
* A user can have multiple progress logs.
* User ownership is used to protect fitness data.

## Authentication

Firebase Authentication is used to control access to the application.

The authentication flow is:

```text
User
  ↓
Register / Sign In
  ↓
Firebase Authentication
  ↓
Authentication Gate
  ↓
Fitness Tracker Application
```

Authenticated users can access the application's protected functionality, while unauthenticated users are directed to the authentication screens.

## Firestore Database

Cloud Firestore is used to store application data.

The main collections include:

```text
workouts
exercises
progressLogs
```

Each record uses a `userId` value to associate the data with its owner.

The Firestore security rules require authentication and check the user's ID before allowing access to protected records.

## Security

The application uses Firebase security rules to restrict access to user-owned data.

For Workout, Exercise, and ProgressLog records, the authenticated user's ID is checked against the `userId` stored in the document.

This helps prevent one authenticated user from accessing another user's fitness records.

## Workout CRUD Operations

The Workout section supports the main CRUD operations:

* **Create:** Add a new workout.
* **Read:** View saved workouts.
* **Update:** Edit an existing workout.
* **Delete:** Remove a workout.

After successfully creating a new workout, the application can display an interstitial advertisement before returning to the previous screen.

## Advertisement System

The application includes advertisement functionality as required by the project.

A banner advertisement is displayed within the workout list so that it appears as part of the scrollable content.

An interstitial advertisement is displayed after successfully creating a new workout.

Advertisement functionality is separated from the main application logic so that advertisement problems do not prevent the main application from operating.

## Firebase Initialization

Firebase is initialized when the application starts using the generated Firebase configuration.

The application also checks whether it is running on the web before initializing the native Google Mobile Ads SDK. This prevents native advertisement plugin errors when running the project in a web browser.

## Error Handling

The application uses validation and error handling during operations such as creating and updating workouts.

If an operation fails, the user receives an error message instead of the application stopping unexpectedly.

## Running the Project

### Requirements

* Flutter SDK
* Dart SDK
* Android Studio or another Flutter-compatible development environment
* Firebase project
* Internet connection for Firebase services

### Installation

Clone the repository:

```bash
git clone https://github.com/amichristian/fitness_tracker.git
```

Open the project folder:

```bash
cd fitness_tracker
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

For web testing:

```bash
flutter run -d chrome
```

## Project Repository

The source code is available on GitHub:

https://github.com/amichristian/fitness_tracker

## Project Structure

```text
fitness_tracker/
│
├── android/
├── ios/
├── lib/
│   ├── models/
│   ├── screens/
│   ├── services/
│   ├── widgets/
│   ├── firebase_options.dart
│   └── main.dart
│
├── web/
├── firebase.json
├── firestore.rules
├── pubspec.yaml
├── README.md
└── storage.rules
```

## Conclusion

Fitness Tracker demonstrates the development of a Flutter application integrated with Firebase services. The project combines authentication, cloud database functionality, user-owned data, advertisement functionality, and a structured Flutter application architecture.

The project provides a foundation for managing workouts and fitness-related information in a single mobile application.
