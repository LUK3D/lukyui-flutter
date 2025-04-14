
![Luky UI splashscreen](assets/splashscreen.png)

# Luky UI

**Luky UI** is a modern Flutter UI library offering highly customizable, feature-rich, and uniquely designed components.

Inspired by shadcn ui, our goal is to bring a similar level of elegance, performance, and practicality to the Flutter ecosystem with fast, beautiful, and essential components for every app.


## ✨ Features

### 🧩 Components
- Buttons  
- Autocomplete / Dropdown  
- User Avatar with 3 Ring Levels  
- Calendar  
- Bézier Curve Editor  
- Customizable 2D Grid with Zoom Support  
- Checker Background  
- Input Fields  
- Alerts  
- Accordion  
- Checkbox  
- Card  
- Badge  
- Ship (custom component)  
- Flow Diagram Editor  

### ⚡ State Management
Luky UI uses Flutter streams and `StatefulWidget`s for internal state handling.  
It includes a `LukyEventSystem` to help you create custom streams and listen or emit specific events within your app.

### 🎨 Theming
Luky UI supports multiple theme definitions—not just light and dark. Easily switch between any number of themes and customize them to your needs.

---

## 🛠️ Utilities

Luky UI also provides utility classes and widgets to simplify common UI behaviors:

- **Predefined sizes** following the Tailwind CSS scale  
- **Predefined shadows** inspired by Tailwind's shadow system  
- `LukyCenterSnapListView` – A `ListView` that snaps to the closest centered item (used in the calendar)  
- `LukyCenteredDetector` – A widget that detects when it’s centered within its parent (also used in the calendar)  
- **Scroll propagation prevention** utility  

...and many more features you can explore in the documentation.

---

## 🚀 Getting Started

### 1. Install the Package

```bash
flutter pub add luky
```

### 2. Wrap Your App (or a Section of It) with `Luky`

You can optionally pass an initial theme:

```dart
Luky(
  initialTheme: lightTheme,
  child: MaterialApp(
    home: YourAppPage(),
  ),
)
```

---

## 🎨 Creating a Custom Theme

You can create a theme by instantiating `LukyThemeData` and optionally customizing the color scheme:

```dart
import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';

final lightTheme = LukyThemeData();

final darkTheme = LukyThemeData(
  colorScheme: LukyColorScheme(
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    onPrimary: Color(0xFF2A2A2A),
    onBackground: Color.fromARGB(255, 119, 119, 119),
    onSurface: Color.fromARGB(255, 160, 160, 160),
    dividerColor: Color(0xFF2B2B2B),
    defaultBackground: Color(0xFF1E1E1E),
    defaultForeground: Color(0xFF9ca3af),
  ),
);
```

---

## 🎯 Accessing Theme Values

You can retrieve the current theme instance from context like this:

```dart
final theme = Luky.of(context).theme;

Text(
  "Simple theme example",
  style: TextStyle(
    fontSize: theme.fontSize.text3Xl,
    fontWeight: FontWeight.bold,
    color: theme.colorScheme.onSurface,
  ),
);
```

---

## 📌 Additional Notes

> ⚠️ This project is still under active development.  
> Expect new components, updates, and enhancements in upcoming releases.  
>  
> 📚 Full documentation will be available soon!
