# Table of Contents
1. [Description](#description)
2. [Getting Started](#getting-started)
3. [Architecture](#architecture)
4. [Project Structure](#project-structure)
5. [Dependencies & Libraries](#dependencies--libraries)
6. [Environment Configuration](#environment-configuration)
7. [Features](#features)
8. [Testing](#testing)
9. [API](#api)
10. [Development Guidelines](#development-guidelines)

# UsersApp

A modern iOS application that fetches and manages random users from the web, built with clean architecture principles and modern Swift concurrency.

## Description

UsersApp is a comprehensive iOS project that demonstrates advanced architectural patterns and modern iOS development practices. The app fetches random users from a REST API, allows users to view detailed information, and provides bookmark functionality with local persistence using Core Data.

The project is designed for developers with intermediate to advanced iOS experience and showcases:
- **MVVM-C Architecture** with Coordinator pattern
- **Clean Architecture** with clear separation of concerns
- **Dependency Injection** using Swinject
- **Modern Swift Concurrency** (async/await)
- **Comprehensive Testing** with mocking frameworks
- **Multi-environment Support** (Development, QA, Production)
- **Firebase Integration** for analytics and remote configuration

## Getting Started

### Prerequisites
- **Xcode 14.0+** (compatible with iOS 14.0+)
- **Swift 5.7+**
- **macOS 12.0+**

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd UsersApp
   ```

2. Open the project in Xcode:
   ```bash
   open UsersApp/UsersApp.xcodeproj
   ```

3. Let Swift Package Manager download dependencies automatically

4. Select your desired scheme:
   - **UsersApp-Dev** for Development
   - **UsersApp-QA** for QA/Staging
   - **UsersApp-Prod** for Production

5. Build and run the project (⌘+R)

### First Launch
Upon launching, you'll see a tab bar with two main sections:
- **Users Tab**: Displays a list of random users fetched from the API
- **Bookmarks Tab**: Shows locally saved users

## Architecture

### MVVM-C Pattern
The app follows the **Model-View-ViewModel-Coordinator (MVVM-C)** architecture:

- **Model**: Domain entities and business logic
- **View**: UIKit-based view controllers and views (programmatically created)
- **ViewModel**: Business logic and state management
- **Coordinator**: Navigation flow and dependency injection

### Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│              Presentation               │
│  (ViewControllers, ViewModels, UI)     │
├─────────────────────────────────────────┤
│                Domain                   │
│  (Entities, Use Cases, Repositories)   │
├─────────────────────────────────────────┤
│                 Data                    │
│  (DataSources, DTOs, Mappers, CoreData)│
└─────────────────────────────────────────┘
```

### Key Architectural Patterns
- **Repository Pattern**: Abstracts data sources
- **Use Case Pattern**: Encapsulates business logic
- **Dependency Injection**: Using Swinject for loose coupling
- **Coordinator Pattern**: Handles navigation flow
- **Protocol-Oriented Programming**: Extensive use of protocols

## Project Structure

```
UsersApp/
├── Configuration/           # Environment & App setup
│   ├── Environment.swift
│   ├── EnvironmentManager.swift
│   └── AppDelegate.swift
├── DependencyInjection/     # DI container setup
│   ├── DependencyContainer.swift
│   └── Assemblies/
├── Domain/                  # Business logic layer
│   ├── Entities/
│   ├── UseCases/
│   └── Repositories/
├── Data/                    # Data layer
│   ├── DataSources/
│   ├── DTOs/
│   ├── Mappers/
│   └── Repositories/
├── Networking/              # Network layer
│   ├── Base/
│   ├── Endpoints/
│   ├── Interceptors/
│   └── Services/
├── CoreData/               # Local persistence
│   ├── Generic/
│   └── PersistenceStore.swift
├── Firebase/               # Firebase integration
│   ├── Analytics/
│   └── RemoteConfig/
├── Presentation/           # UI layer
│   ├── Coordinator/
│   ├── Navigation/
│   └── UI/
├── Extensions/             # Swift extensions
└── Resources/              # Assets, strings, etc.
```

## Dependencies & Libraries

### Core Dependencies
- **Swinject (2.10.0)**: Dependency injection framework
- **Kingfisher (7.9.1)**: Image loading and caching
- **Lottie (4.5.2)**: Animation framework

### Firebase Suite
- **FirebaseAnalytics (12.3.0)**: User analytics and tracking
- **FirebaseCrashlytics (12.3.0)**: Crash reporting
- **FirebaseFirestore (12.3.0)**: Cloud database (future use)
- **FirebaseRemoteConfig (12.3.0)**: Remote configuration

### Development & Testing
- **Cuckoo (2.1.1)**: Mocking framework for unit tests
- **Pulse (5.1.4)**: Network debugging and logging
- **SwiftLint**: Code style and quality enforcement

### Supporting Libraries
- **SwiftSyntax (602.0.0)**: Swift syntax analysis (for Cuckoo)
- **SwiftArgumentParser (1.6.1)**: Command-line argument parsing
- **TOMLKit (0.6.0)**: TOML configuration parsing

## Environment Configuration

The app supports three distinct environments with different configurations:

### Development Environment
- **Bundle ID**: `com.oguztandogan.usersapp.dev`
- **App Name**: "UsersApp Dev"
- **Analytics**: Disabled
- **Crashlytics**: Disabled
- **Debug Menu**: Enabled
- **Log Level**: Debug

### QA/Staging Environment
- **Bundle ID**: `com.oguztandogan.usersapp.qa`
- **App Name**: "UsersApp QA"
- **Analytics**: Enabled
- **Crashlytics**: Enabled
- **Debug Menu**: Disabled
- **Log Level**: Info

### Production Environment
- **Bundle ID**: `com.oguztandogan.usersapp`
- **App Name**: "UsersApp"
- **Analytics**: Enabled
- **Crashlytics**: Enabled
- **Debug Menu**: Disabled
- **Log Level**: Error

## Features

### Core Features
- **User List**: Fetches and displays random users with pagination
- **User Details**: Detailed view with user information and photos
- **Bookmark System**: Save/remove users to/from local storage
- **Offline Support**: View bookmarked users without internet
- **Pull-to-Refresh**: Refresh user list with gesture
- **Infinite Scrolling**: Load more users as you scroll

### Technical Features
- **Multi-Environment Support**: Seamless switching between dev/qa/prod
- **Firebase Analytics**: Comprehensive user behavior tracking
- **Remote Configuration**: Dynamic feature flags and settings
- **Error Handling**: Robust error management with user feedback
- **Loading States**: Smooth loading animations and indicators
- **Image Caching**: Efficient image loading with Kingfisher
- **Localization**: Multi-language support ready

### UI/UX Features
- **Programmatic UI**: No Storyboards, fully programmatic interface
- **Modern Design**: Clean, Material Design-inspired interface
- **Dark Mode Ready**: Prepared for dark mode implementation
- **Accessibility**: VoiceOver and accessibility support
- **Responsive Design**: Adapts to different screen sizes

## Testing

### Test Coverage
The project includes comprehensive unit tests covering:
- **ViewModels**: Business logic testing with mocked dependencies
- **Use Cases**: Domain logic validation
- **Repositories**: Data layer integration testing
- **Network Services**: API communication testing
- **Data Sources**: Local and remote data handling

### Testing Frameworks
- **XCTest**: Apple's testing framework
- **Cuckoo**: Mocking framework for protocol-based testing
- **Async Testing**: Modern async/await testing patterns

### Running Tests
```bash
# Run all tests
⌘+U in Xcode

# Run specific test class
⌘+U → Select test class

# Run tests from command line
xcodebuild test -scheme UsersApp-Dev -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Structure
```
UsersAppTests/
├── ViewModels/          # ViewModel tests
├── UseCases/           # Use case tests
├── Repositories/       # Repository tests
├── DataSources/        # Data source tests
└── Networking/         # Network service tests
```

## API

### External API
- **Base URL**: `https://randomuser.me`
- **Documentation**: [Random User API](https://randomuser.me/api)
- **Rate Limiting**: No official limits, but reasonable usage expected

### API Endpoints
- **GET /api**: Fetch random users
  - Parameters: `page`, `results`, `seed`
  - Response: JSON with user data and pagination info

### Network Layer Features
- **Modern Concurrency**: async/await based networking
- **Request Interceptors**: Logging and debugging support
- **Error Handling**: Comprehensive error management
- **Timeout Configuration**: Environment-specific timeouts
- **Retry Logic**: Automatic retry for failed requests

## Development Guidelines

### Code Style
- **SwiftLint**: Enforced code style and quality
- **Naming Conventions**: Clear, descriptive naming
- **Documentation**: Comprehensive code documentation
- **Comments**: Meaningful comments for complex logic

### Architecture Guidelines
- **Single Responsibility**: Each class has one clear purpose
- **Dependency Inversion**: Depend on abstractions, not concretions
- **Protocol-Oriented**: Extensive use of protocols
- **Immutable Design**: Prefer immutable data structures

### Concurrency Guidelines
- **MainActor**: UI updates on main thread
- **Sendable**: Thread-safe data structures
- **Actor Isolation**: Protected mutable state
- **Async/Await**: Modern concurrency patterns

### Testing Guidelines
- **AAA Pattern**: Arrange, Act, Assert
- **Mocking**: Use Cuckoo for protocol mocking
- **Coverage**: Aim for high test coverage
- **Isolation**: Each test is independent

## Future Enhancements

### Planned Features
- **User Profiles**: Extended user profile management
- **Search Functionality**: Search through users and bookmarks
- **Sync Capabilities**: Cloud synchronization of bookmarks
- **Push Notifications**: User engagement notifications
- **Dark Mode**: Complete dark mode implementation
- **Widgets**: iOS home screen widgets

### Technical Improvements
- **Combine Integration**: Reactive programming patterns
- **Performance Optimization**: Memory and CPU optimization
- **Accessibility**: Enhanced accessibility features

---

*Built with ❤️ using Swift and modern iOS development practices*
