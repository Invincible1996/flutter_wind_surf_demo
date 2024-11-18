# flutter_wind_surf_demo

A modern Flutter application demonstrating the integration of WebView functionality with a robust architecture and user-friendly features.

## Features

- **Responsive WebView Integration**: Seamless web content display within the app
- **Theme Customization**: Support for both light and dark themes
- **Authentication**: Secure user authentication system
- **Navigation**: Auto-route based navigation for smooth screen transitions
- **Settings Management**: User-configurable app settings
- **Drawer Navigation**: Easy access to main app features

## Project Structure

```
lib/
├── features/
│   ├── auth/         # Authentication related code
│   └── settings/     # App settings and theme management
├── routes/           # App routing configuration
├── screens/          # Main app screens
└── widgets/          # Reusable UI components
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
![Home Screen - Light](/screenshots/home_light.png)
![Settings - Light](/screenshots/settings_light.png)

### Dark Theme
![Home Screen - Dark](/screenshots/home_dark.png)
![Settings - Dark](/screenshots/settings_dark.png)

## Dependencies

- auto_route: For declarative routing
- flutter_bloc: State management
- webview_flutter: WebView functionality
- shared_preferences: Local data storage

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
