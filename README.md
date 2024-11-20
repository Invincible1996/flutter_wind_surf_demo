# flutter_wind_surf_demo

A modern Flutter application demonstrating the integration of WebView functionality with a robust architecture and user-friendly features.

## Features

- **Responsive WebView Integration**: Seamless web content display within the app
- **Theme Customization**: Support for both light and dark themes using Riverpod
- **Authentication**: Secure user authentication system with Riverpod state management
- **Customer Management**: CRUD operations for customer data
- **Navigation**: Auto-route based navigation for smooth screen transitions
- **Settings Management**: User-configurable app settings
- **Drawer Navigation**: Easy access to main app features

## Project Structure

```
lib/
├── features/
│   ├── auth/              # Authentication feature
│   │   ├── presentation/
│   │   │   ├── pages/    # Auth-related screens
│   │   │   ├── providers/# Auth state providers
│   │   │   └── widgets/  # Auth-specific widgets
│   ├── customer/          # Customer management feature
│   │   └── presentation/
│   │       ├── pages/    # Customer-related screens
│   │       ├── providers/# Customer state providers
│   │       └── state/    # Customer state definitions
│   ├── theme/            # Theme management
│   │   └── presentation/
│   │       └── providers/# Theme state providers
│   └── settings/         # App settings
├── routes/               # App routing configuration
└── injection_container.dart  # Dependency injection setup
```

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK
- Android Studio / VS Code with Flutter plugins

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/flutter_wind_surf_demo.git
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Screenshots

### Light Theme

<table>
  <tr>
    <td><img src="/screenshots/home_light.png" width="400"></td>
    <td><img src="/screenshots/settings_light.png" width="400"></td>
  </tr>
</table>

### Dark Theme

<table>
  <tr>
    <td><img src="/screenshots/home_dark.png" width="400"></td>
    <td><img src="/screenshots/settings_dark.png" width="400"></td>
  </tr>
</table>

## Dependencies

### Production Dependencies
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) ^2.4.9 - Reactive state management
- [riverpod_annotation](https://pub.dev/packages/riverpod_annotation) ^2.3.3 - Code generation for Riverpod
- [auto_route](https://pub.dev/packages/auto_route) ^7.8.4 - Declarative routing solution
- [cupertino_icons](https://pub.dev/packages/cupertino_icons) ^1.0.6 - iOS style icons
- [dartz](https://pub.dev/packages/dartz) ^0.10.1 - Functional programming features
- [equatable](https://pub.dev/packages/equatable) ^2.0.5 - Value equality comparison
- [freezed_annotation](https://pub.dev/packages/freezed_annotation) ^2.4.1 - Code generation for immutable classes
- [get_it](https://pub.dev/packages/get_it) ^7.6.7 - Service locator for dependency injection
- [http](https://pub.dev/packages/http) ^1.2.1 - HTTP networking package
- [internet_connection_checker](https://pub.dev/packages/internet_connection_checker) ^1.0.0+1 - Network connectivity checker
- [path](https://pub.dev/packages/path) ^1.8.3 - Path manipulation operations
- [shared_preferences](https://pub.dev/packages/shared_preferences) ^2.2.2 - Persistent storage
- [sqflite](https://pub.dev/packages/sqflite) ^2.3.2 - SQLite database
- [url_launcher](https://pub.dev/packages/url_launcher) ^6.2.1 - URL handling and launching
- [webview_flutter](https://pub.dev/packages/webview_flutter) ^4.4.2 - WebView widget

### Development Dependencies
- [riverpod_generator](https://pub.dev/packages/riverpod_generator) ^2.3.9 - Code generation for Riverpod
- [auto_route_generator](https://pub.dev/packages/auto_route_generator) ^7.3.2 - Code generation for auto_route
- [build_runner](https://pub.dev/packages/build_runner) ^2.4.8 - Code generation tool
- [freezed](https://pub.dev/packages/freezed) ^2.4.5 - Code generation for data classes
- [flutter_lints](https://pub.dev/packages/flutter_lints) ^3.0.0 - Recommended lints for Flutter apps

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
