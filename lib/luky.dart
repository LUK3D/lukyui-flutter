import 'package:flutter/material.dart';
import 'utils/scroll_manager.dart';
import 'utils/theme/luky_theme.dart';

class Luky extends StatefulWidget {
  final Widget child;
  final LukyThemeData initialTheme;

  const Luky({
    super.key,
    required this.child,
    required this.initialTheme,
  });

  @override
  State<Luky> createState() => LukyState();

  static LukyState of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_LukyInheritedTheme>();
    assert(inherited != null, 'No LukyTheme found in context');
    return inherited!.themeState;
  }
}

class LukyState extends State<Luky> {
  late LukyThemeData _currentTheme;
  final LukyScrollsManager scrollsManager = LukyScrollsManager();

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.initialTheme;
  }

  LukyThemeData get theme => _currentTheme;

  void setTheme(LukyThemeData newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _LukyInheritedTheme(
      themeState: this,
      child: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme(
                primary: _currentTheme.colorScheme.primary,
                secondary: _currentTheme.colorScheme.secondary,
                surface: _currentTheme.colorScheme.surface,
                error: _currentTheme.colorScheme.error,
                onPrimary: _currentTheme.colorScheme.onPrimary,
                onSecondary: _currentTheme.colorScheme.onSecondary,
                onSurface: _currentTheme.colorScheme.onSurface,
                onError: _currentTheme.colorScheme.onError,
                brightness: Brightness.light,
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                  fontSize: _currentTheme.fontSize.text4Xl,
                  color: _currentTheme.colorScheme.onSurface,
                  height: 1,
                ),
                bodyMedium: TextStyle(
                  fontSize: _currentTheme.fontSize.textXl,
                  color: _currentTheme.colorScheme.onSurface,
                  height: 1,
                ),
                bodySmall: TextStyle(
                  fontSize: _currentTheme.fontSize.textLg,
                  color: _currentTheme.colorScheme.onSurface,
                  height: 1,
                ),
              )),
          child: widget.child),
    );
  }
}

class _LukyInheritedTheme extends InheritedWidget {
  final LukyState themeState;

  const _LukyInheritedTheme({
    required super.child,
    required this.themeState,
  });

  @override
  bool updateShouldNotify(_LukyInheritedTheme oldWidget) {
    return oldWidget.themeState._currentTheme != themeState._currentTheme;
  }
}
