import 'package:flutter/material.dart';

const Color _lightPrimaryColor = Colors.white;
final Color _lightPrimaryColorLight = Colors.grey[200];
final Color _lightPrimaryColorDark = Colors.grey[600];
const Color _lightSecondaryColor = Color(0xFF218AE6);
const Color _lightSecondaryColorDark = Color(0xFF005EB3);

final Color _darkPrimaryColor = Colors.grey[300];
final Color _darkPrimaryColorDark = Colors.grey[600];
const Color _darkSecondaryColor = Color(0xFF009BEB);
const Color _darkSecondaryColorDark = Color(0xFF009BEB);

class ActionBarThemeData {
  const ActionBarThemeData({@required this.data});

  final ThemeData data;

  Color get color => _lightSecondaryColor;

  Color get iconColor => _lightSecondaryColor;

  Color get selectedItemColor => _lightSecondaryColorDark;

  Color get selectedItemBackgroundColor => (data.brightness == Brightness.light)
      ? Colors.blue[50]
      : Colors.blue[100];
}

class ItemCardThemeData {
  const ItemCardThemeData({@required this.data});

  final ThemeData data;

  Color get color => Colors.white;

  Color get backgroundColor => Colors.blue[50];

  Color get saturationColor => Colors.blue[50];

  Color get ownedColor => const Color(0xFFE60012);

  Color get missedColor => const Color(0xFF44B035);
}

class BottomNavBarThemeData {
  const BottomNavBarThemeData({@required this.data});

  final ThemeData data;

  Color get backgroundColor => data.canvasColor;

  Color get selectedItemColor => _lightSecondaryColor;

  Color get unselectedItemColor => Colors.grey[500];
}

class CircularProgressIndicatorThemeData {
  const CircularProgressIndicatorThemeData({@required this.data});

  final ThemeData data;

  Color get color => const Color(0xFF009BEB);
}

ThemeData buildTheme(Brightness brightness) {
  ThemeData base;
  if (brightness == Brightness.dark) {
    base = ThemeData.dark();
    base = base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: _darkPrimaryColor,
        primaryVariant: _darkPrimaryColorDark,
        secondary: _darkSecondaryColor,
        secondaryVariant: _lightSecondaryColorDark,
        surface: Colors.blue[50],
        background: Colors.black,
        onPrimary: _darkSecondaryColor,
        onSecondary: Colors.white,
        onSurface: Colors.black,
      ),
      textTheme: base.textTheme.copyWith(
        headline: const TextStyle(
          color: _lightSecondaryColor,
        ),
        subhead: TextStyle(
          color: Colors.blue[100],
        ),
        subtitle: const TextStyle(
          color: _lightSecondaryColor,
        ),
        body1: const TextStyle(
          color: _lightSecondaryColor,
        ),
        body2: const TextStyle(
          color: _lightSecondaryColor,
        ),
        caption: const TextStyle(
          color: Colors.white,
        ),
      ),
      toggleableActiveColor: const Color(0xFF009BEB),
      iconTheme: const IconThemeData(
        color: _lightSecondaryColor,
      ),
      primaryIconTheme: const IconThemeData(
        color: _darkSecondaryColorDark,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: const Color(0xFF009BEB),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF009BEB),
      ),
    );
  } else {
    base = ThemeData.light();
    base = base.copyWith(
      primaryColor: _lightPrimaryColor,
      primaryColorLight: _lightPrimaryColorLight,
      primaryColorDark: _lightPrimaryColorDark,
      accentColor: _lightSecondaryColor,
      textTheme: base.textTheme.copyWith(
        headline: const TextStyle(
          color: _lightSecondaryColorDark,
        ),
        display4: TextStyle(
          color: Colors.grey[500],
        ),
        subtitle: const TextStyle(
          color: _lightSecondaryColorDark,
        ),
        body1: const TextStyle(
          color: Color(0xFF1F4882),
        ),
        body2: const TextStyle(
          color: Color(0xFF1F4882),
        ),
        caption: const TextStyle(
          color: Colors.black,
        ),
      ),
      iconTheme: const IconThemeData(
        color: _lightSecondaryColor,
      ),
      appBarTheme: AppBarTheme(
        brightness: brightness,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: _lightSecondaryColorDark,
        ),
        actionsIconTheme: const IconThemeData(
          color: _lightSecondaryColorDark,
        ),
        textTheme: TextTheme(
          title: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
          headline: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ),
      primaryIconTheme: const IconThemeData(
        color: _lightSecondaryColorDark,
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.normal,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF009BEB),
      ),
    );
  }
  return base;
}
