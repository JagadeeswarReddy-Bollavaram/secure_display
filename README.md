# Secure Screen

A Flutter package for secure screen protection with screenshot and screen recording prevention.

## Getting Started

This package provides widgets and utilities for preventing screenshots and screen recording in Flutter applications.

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  secure_screen:
    path: ../secure-screen
```

Or if published:

```yaml
dependencies:
  secure_screen: ^0.1.0
```

### Usage

```dart
import 'package:secure_screen/secure_screen.dart';
```

## Features

### Secure Screen

The `SecureScreen` prevents screen recording and screenshots on both iOS and Android when active.

#### Basic Usage

```dart
import 'package:secure_screen/secure_screen.dart';

class SecureScreen extends StatefulWidget {
  @override
  _SecureScreenState createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  late SecureScreen _secureScreen;

  @override
  void initState() {
    super.initState();
    _secureScreen = SecureScreen();
    _secureScreen.activate(); // Automatically restricts
  }

  @override
  void dispose() {
    _secureScreen.dispose(); // Automatically unrestricts
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Secure Screen')),
      body: Center(
        child: Text('This screen is protected from recording'),
      ),
    );
  }
}
```

#### Manual Control

```dart
final secureScreen = SecureScreen();

// Activate screen protection
await secureScreen.activate();

// Later, dispose to automatically unrestrict
await secureScreen.dispose();
```

### Secure Screen Controller (GetX)

The `SecureScreenController` extends `GetxController` and automatically manages screen security lifecycle when used with GetX dependency injection.

#### Usage with GetX

```dart
import 'package:get/get.dart';
import 'package:secure_screen/secure_screen.dart';

// Put the controller (automatically activates screen protection)
Get.put(SecureScreenController());

// Use it anywhere in your app
final controller = Get.find<SecureScreenController>();
print(controller.isSecure); // true

// Delete when done (automatically deactivates screen protection)
Get.delete<SecureScreenController>();
```

### Secure Screen Widget

The `SecureScreenWidget` is a declarative widget that automatically manages screen restriction lifecycle. When the widget is in the widget tree, screen restriction is active. When removed, it's automatically disposed. No manual lifecycle management needed!

#### Usage

```dart
import 'package:secure_screen/secure_screen.dart';

class MySecurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecureScreenWidget(
      child: Scaffold(
        appBar: AppBar(title: Text('Secure Page')),
        body: Center(
          child: Text('This screen is automatically protected'),
        ),
      ),
    );
  }
}
```

#### With Optional Blur

```dart
SecureScreenWidget(
  useBlur: true, // Use blur overlay if FLAG_SECURE doesn't work
  child: YourWidget(),
)
```

#### Navigation Behavior

**Important:** Screen restriction is applied at the window level, affecting the entire app while active. The behavior depends on your navigation method:

- **`Navigator.push()`**: The original page stays in the widget tree (behind the new page), so `SecureScreenWidget` remains mounted and **restriction stays ACTIVE** on the new page.

- **`Navigator.pushReplacement()`**: The original page is removed from the tree, so `SecureScreenWidget` is disposed and **restriction is REMOVED** on the new page.

**Best Practice:** If you need protection on multiple pages in a flow, wrap each page with `SecureScreenWidget`:

```dart
// Page 1
SecureScreenWidget(
  child: Page1(),
)

// Navigate to Page 2
Navigator.push(context, MaterialPageRoute(
  builder: (context) => SecureScreenWidget(
    child: Page2(), // Also protected!
  ),
));
```

The widget automatically:
- Activates screen restriction when mounted
- Disposes screen restriction when unmounted
- Handles errors gracefully (widget still renders even if restriction fails)

## Platform Support

- **Android**: Uses `FLAG_SECURE` to prevent screenshots and screen recording
- **iOS**: Uses secure text field technique and screen recording monitoring

## Example

See the `example` directory for a complete example app.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Jagadeeswar Bollavaram

