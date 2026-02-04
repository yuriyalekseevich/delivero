# Delivero - Delivery Management App

A comprehensive Flutter application for delivery management with real-time tracking, offline capabilities, and advanced mapping features.

## 🚀 Features

### Core Functionality
- **Delivery Management**: Create, update, and track deliveries with full CRUD operations
- **Real-time Location Tracking**: GPS-based location services with background tracking
- **Interactive Maps**: Google Maps integration with custom markers and clustering
- **Offline Support**: Full offline functionality with automatic sync when online
- **Multi-language Support**: Internationalization with English and Spanish
- **Dark/Light Theme**: Adaptive theming with user preference

### Advanced Features
- **Pagination**: Efficient data loading with pagination support
- **Search & Filter**: Advanced filtering by status, date, and customer
- **Status Management**: Visual status indicators with color-coded markers
- **Export Functionality**: PDF generation and sharing capabilities
- **Debug Tools**: Comprehensive debugging and logging system

### Architecture
- **Clean Architecture**: SOLID principles with clear separation of concerns
- **State Management**: BLoC pattern for reactive state management
- **Dependency Injection**: GetIt with Injectable for clean dependency management
- **Local Storage**: Hive database for offline data persistence
- **Network Layer**: Dio HTTP client with interceptors and error handling

## 🛠️ Technical Stack

### Core Technologies
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **BLoC**: State management pattern
- **GetIt**: Dependency injection
- **Injectable**: Code generation for DI

### Data & Storage
- **Hive**: Local NoSQL database
- **Dio**: HTTP client for API communication
- **Shared Preferences**: User settings storage

### Maps & Location
- **Google Maps Flutter**: Interactive mapping
- **Geolocator**: Location services
- **Geocoding**: Address resolution

### UI/UX
- **Material Design**: Modern UI components
- **Custom Themes**: Adaptive theming system
- **Responsive Design**: Multi-screen support

## 📱 Screenshots

The app features a modern, intuitive interface with:
- Delivery list with status indicators
- Interactive map with custom markers
- Real-time location tracking
- Offline mode indicators
- Multi-language support

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.2.0)
- Dart SDK (>=3.2.0)
- Android Studio / VS Code
- iOS Simulator / Android Emulator
- Google Maps API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd delivero
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure Google Maps API Key**

   **For Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
              android:value="YOUR_API_KEY_HERE"/>
   ```

   **For iOS** (`ios/Runner/Info.plist`):
   ```xml
   <key>GMSApiKey</key>
   <string>YOUR_API_KEY_HERE</string>
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

### Google Maps Setup

1. **Create Google Cloud Project**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing

2. **Enable APIs**
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Geocoding API

3. **Create API Key**
   - Go to "APIs & Services" → "Credentials"
   - Create new API key
   - Configure restrictions as needed

4. **Set up Billing**
   - Enable billing account (required for Maps API)
   - Set up payment method

## 🏗️ Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── localization/       # Internationalization
│   ├── network/            # Network layer
│   ├── offline/            # Offline functionality
│   ├── services/           # Core services
│   ├── storage/            # Data persistence
│   └── theme/              # Theming system
├── features/               # Feature modules
│   └── delivery/           # Delivery feature
│       ├── data/           # Data layer
│       ├── domain/         # Domain layer
│       └── presentation/   # Presentation layer
├── generated/              # Generated code
└── l10n/                   # Localization files
```

## 🔧 Architecture Overview

### Clean Architecture Implementation

The project follows Clean Architecture principles with clear separation:

- **Presentation Layer**: UI components, BLoC state management
- **Domain Layer**: Business logic, entities, use cases
- **Data Layer**: Repositories, data sources, models

### SOLID Principles

- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Derived classes are substitutable for base classes
- **Interface Segregation**: Clients depend only on interfaces they use
- **Dependency Inversion**: Depend on abstractions, not concretions

### State Management

The app uses BLoC pattern for state management:

```dart
// Example BLoC implementation
class DeliveryCubit extends Cubit<DeliveryState> {
  final DeliveryRepository _repository;
  
  DeliveryCubit(this._repository) : super(DeliveryInitial());
  
  Future<void> loadDeliveries() async {
    emit(DeliveryLoading());
    try {
      final deliveries = await _repository.getDeliveries();
      emit(DeliveryLoaded(deliveries));
    } catch (e) {
      emit(DeliveryError(e.toString()));
    }
  }
}
```

## 📊 Data Flow

1. **User Interaction** → UI triggers BLoC event
2. **BLoC Processing** → Business logic execution
3. **Repository Call** → Data layer interaction
4. **State Emission** → UI updates reactively

## 🔄 Offline Support

The app provides comprehensive offline functionality:

- **Local Storage**: Hive database for data persistence
- **Action Queue**: Queued operations for offline actions
- **Sync Mechanism**: Automatic sync when connection restored
- **Conflict Resolution**: Smart conflict handling

## 🌍 Internationalization

Multi-language support with:
- **English**: Default language
- **Spanish**: Full translation
- **Extensible**: Easy to add more languages

## 🎨 Theming

Adaptive theming system with:
- **Light Theme**: Clean, modern light interface
- **Dark Theme**: Eye-friendly dark mode
- **System Theme**: Follows device preference
- **Custom Colors**: Brand-specific color schemes

## 🧪 Testing

The project includes comprehensive testing:

- **Unit Tests**: Business logic testing
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end testing
- **BLoC Tests**: State management testing

Run tests:
```bash
flutter test
```

## 📦 Build & Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔧 Development Tools

### Code Generation
- **Injectable**: Dependency injection
- **Hive**: Database code generation
- **JSON Serializable**: Model serialization
- **Internationalization**: Localization code generation

#### Generate Localization Files
```bash
# Generate localization files from .arb files
flutter pub run intl_utils:generate

# Or use the shorter version
flutter pub run intl_utils:generate
```

This command generates the necessary Dart files for internationalization from the `.arb` files in the `l10n/` directory.

### Linting
- **Flutter Lints**: Code quality rules
- **Custom Rules**: Project-specific linting

### Debugging
- **Debug Page**: Comprehensive debugging tools
- **Network Logging**: API request/response logging
- **State Inspection**: BLoC state debugging

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Maps team for mapping services
- BLoC library contributors
- Open source community

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the code examples

---

**Delivero** - Professional delivery management made simple.# delivero
