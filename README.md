# DreamDwell - Property Listing Mobile App

A modern Flutter mobile application for browsing and managing property listings, built with clean architecture principles and featuring advanced search capabilities, favorites management, and smooth animations.

## Features

- **Property Browsing**: Browse through a curated list of properties with detailed information
- **Advanced Search**: Filter properties by location, property type, and text search
- **Favorites Management**: Save and manage favorite properties with persistent storage
- **Property Details**: View comprehensive property information with high-quality images
- **Smooth Animations**: Staggered list animations, shimmer loading effects, and button feedback
- **Responsive Design**: Optimized for different screen sizes and orientations
- **Clean UI/UX**: Modern design with intuitive navigation and user-friendly interface

## How to Set Up and Run the App

### Prerequisites

- Flutter SDK (3.7.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (for iOS testing) or Android Emulator

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dreamdwell
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For debug mode
   flutter run
   
   # For release mode
   flutter run --release
   
   # For specific device
   flutter run -d <device-id>
   ```

4. **Build the app**
   ```bash
   # Android APK
   flutter build apk
   
   # iOS (requires macOS and Xcode)
   flutter build ios
   ```

### Project Structure
```
lib/
├── core/                           # Core functionality
│   ├── routes/                     # Navigation and routing
│   ├── services/                   # Network and API services
│   ├── shared/                     # Shared widgets and utilities
│   ├── theme/                      # App theming and colors
│   └── utils/                      # Utility functions and constants
├── features/                       # Feature-based modules
│   ├── pages/                      # Main application pages
│   ├── properties/                 # Property feature module
│   │   ├── data/                   # Data layer (models, repositories, datasources)
│   │   ├── domain/                 # Domain layer (entities, repositories, use cases)
│   │   └── presentation/           # Presentation layer (providers, pages, widgets)
│   └── splash/                     # Splash and onboarding
└── main.dart                       # Application entry point
```

## 🛠️ Tools and Libraries Used

### Core Framework
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language for Flutter development

### State Management
- **Provider**: State management solution for reactive programming
- **ChangeNotifier**: For managing and notifying state changes

### Architecture & Dependency Injection
- **Clean Architecture**: Separation of concerns with Domain, Data, and Presentation layers
- **get_it**: Service locator for dependency injection
- **dartz**: Functional programming with Either types for error handling

### Navigation
- **Named Routes**: Centralized routing with route names and arguments
- **Custom Router**: AppRouter for handling route generation and navigation

### UI & Animations
- **Custom Widgets**: Reusable UI components with consistent styling
- **Staggered Animations**: Smooth property card entrance animations
- **Shimmer Loading**: Skeleton loading effects during data fetching
- **Button Feedback**: Animated button interactions for better UX

### Data & Networking
- **Local JSON**: Property data stored in assets for demo purposes
- **Repository Pattern**: Abstraction layer for data access
- **Use Cases**: Business logic encapsulation

### Styling & Theming
- **Google Fonts**: Custom typography with DM Sans font family
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Custom Theme**: Consistent color scheme and styling throughout the app

### Development Tools
- **flutter_lints**: Code quality and style enforcement
- **Dart Analyzer**: Static code analysis for error detection

## Approach and Thought Process

### Architecture Decision
I chose **Clean Architecture** to ensure:
- **Separation of Concerns**: Clear boundaries between business logic, data access, and UI
- **Testability**: Easy unit testing with isolated layers
- **Maintainability**: Scalable codebase that's easy to modify and extend
- **Dependency Inversion**: High-level modules don't depend on low-level modules

### Feature-Based Structure
- **Modular Design**: Each feature (properties, splash, etc.) is self-contained
- **Scalability**: Easy to add new features without affecting existing code
- **Team Collaboration**: Multiple developers can work on different features simultaneously

### State Management Strategy
- **Provider Pattern**: Chosen for its simplicity and Flutter integration
- **Immutable State**: PropertyState class ensures predictable state changes
- **Single Source of Truth**: Centralized state management prevents inconsistencies

### UI/UX Design Philosophy
- **Mobile-First**: Designed specifically for mobile devices with touch interactions
- **Progressive Enhancement**: Core functionality works, animations enhance the experience
- **Accessibility**: Semantic widgets and proper contrast ratios
- **Performance**: Efficient rendering with lazy loading and optimized widgets

### Data Management
- **Repository Pattern**: Abstracts data sources (local/remote) from business logic
- **Local-First**: Properties cached locally for offline access and better performance
- **Favorites Persistence**: In-memory storage for demo (easily upgradeable to SharedPreferences/SQLite)

## Limitations, Trade-offs, and Future Improvements

### Current Limitations

1. **Data Storage**
   - **Limitation**: Properties are loaded from static JSON file
   - **Trade-off**: Simplifies demo setup but lacks real-time data updates
   - **Improvement**: Integrate with REST API or GraphQL backend

2. **Favorites Persistence**
   - **Limitation**: Favorites stored in memory (lost on app restart)
   - **Trade-off**: Avoids platform-specific storage complexity for demo
   - **Improvement**: Implement SharedPreferences or SQLite for persistence

3. **Image Management**
   - **Limitation**: Property images are placeholder assets
   - **Trade-off**: Reduces app size and network dependency
   - **Improvement**: Implement image caching with packages like `cached_network_image`

4. **Search Functionality**
   - **Limitation**: Basic text and filter search only
   - **Trade-off**: Simple implementation vs advanced search features
   - **Improvement**: Add price range filters, map-based search, and advanced sorting

### Technical Trade-offs

1. **State Management**
   - **Choice**: Provider over Bloc/Riverpod
   - **Reason**: Simpler learning curve and sufficient for app complexity
   - **Alternative**: Bloc for more complex state management scenarios

2. **Navigation**
   - **Choice**: Named routes over AutoRoute
   - **Reason**: Built-in Flutter solution, no additional dependencies
   - **Alternative**: AutoRoute for route definitions and reducing of boilerplate

3. **Animation Complexity**
   - **Choice**: Simple staggered animations over complex hero animations
   - **Reason**: Better performance and easier maintenance
   - **Alternative**: More sophisticated animations for premium feel

### Future Improvements

#### Features
- **User Authentication**: Login/signup with social media integration
- **Property Comparison**: Side-by-side property comparison tool
- **Map Integration**: Interactive map with property locations
- **Push Notifications**: Alerts for new properties matching user preferences
- **Offline Mode**: Full offline functionality with sync capabilities
- **Property Sharing**: Share properties via social media or messaging

#### Technical Enhancements
- **Performance Optimization**: 
  - Image lazy loading and caching
  - Virtual scrolling for large lists
  - Background data synchronization
- **Testing Coverage**:
  - Unit tests for business logic
  - Widget tests for UI components
  - Integration tests for user flows
- **Accessibility**:
  - Screen reader support
  - High contrast mode
  - Font scaling support
- **Internationalization**: Multi-language support with `flutter_intl`

#### Architecture Improvements
- **Microservices**: Split backend into specialized services
- **GraphQL**: More efficient data fetching with query optimization
- **Real-time Updates**: WebSocket integration for live property updates
- **Caching Strategy**: Multi-level caching (memory, disk, CDN)

## Performance Considerations

- **Lazy Loading**: Properties loaded on-demand to reduce initial load time
- **Efficient Rendering**: ListView.builder for optimal memory usage
- **Image Optimization**: Placeholder images to prevent layout shifts
- **State Optimization**: Minimal rebuilds with targeted Provider consumers

## Testing Strategy

While not implemented in this demo, the architecture supports:
- **Unit Tests**: For use cases, repositories, and providers
- **Widget Tests**: For individual UI components
- **Integration Tests**: For complete user workflows
- **Golden Tests**: For UI consistency across different devices

## Code Quality

- **Linting**: Strict linting rules with flutter_lints
- **Documentation**: Comprehensive inline documentation
- **Type Safety**: Strong typing throughout the codebase
- **Error Handling**: Proper error handling with Either types

---

**Built using Flutter**

*This project demonstrates modern Flutter development practices with clean architecture, efficient state management, and polished user experience.*