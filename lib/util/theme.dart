import 'package:flutter/material.dart';

const Color _lightPrimaryColor = Colors.white; //Colors.grey[300];
final Color _lightPrimaryColorLight = Colors.grey[200];
final Color _lightPrimaryColorDark = Colors.grey[600];
const Color _lightSecondaryColor = Color(0xFF218AE6);
// const Color _lightSecondaryColorLight = Color(0xFF6BB9FF);
const Color _lightSecondaryColorDark = Color(0xFF005EB3);

final Color _darkPrimaryColor = Colors.grey[300];
final Color _darkPrimaryColorLight = Colors.grey[200];
final Color _darkPrimaryColorDark = Colors.grey[600];
final Color _darkSecondaryColor = Colors.teal[200];
final Color _darkSecondaryColorLight = Colors.teal[100];
final Color _darkSecondaryColorDark = Colors.teal[700];

class ActionBarThemeData {
  const ActionBarThemeData({@required this.data});

  final ThemeData data;

  Color get color => (data.brightness == Brightness.light)
      ? Colors.black
      : _darkSecondaryColorDark;

  Color get iconColor => (data.brightness == Brightness.light)
      ? Colors.black
      : _darkSecondaryColorDark;

  Color get selectedItemColor => (data.brightness == Brightness.light)
      ? _lightSecondaryColorDark
      : _darkSecondaryColorLight;

  Color get selectedItemBackgroundColor => (data.brightness == Brightness.light)
      ? Colors.blue[50]
      : _darkSecondaryColorDark;
}

class ItemCardThemeData {
  const ItemCardThemeData({@required this.data});

  final ThemeData data;

  Color get color =>
      (data.brightness == Brightness.light) ? Colors.white : Colors.white;

  Color get backgroundColor1 => (data.brightness == Brightness.light)
      ? const Color(0xFFE60012)
      : const Color(0xFFE60012);

  Color get backgroundColor2 => (data.brightness == Brightness.light)
      ? const Color(0xFF44B035)
      : const Color(0xFFE60012);
}

class BottomNavBarThemeData {
  const BottomNavBarThemeData({@required this.data});

  final ThemeData data;

  Color get backgroundColor => data.canvasColor;

  Color get selectedItemColor => (data.brightness == Brightness.light)
      ? _lightSecondaryColor
      : _darkSecondaryColorLight;

  Color get unselectedItemColor => (data.brightness == Brightness.light)
      ? Colors.grey[500]
      : _darkSecondaryColorDark;
}

class CircularProgressIndicatorThemeData {
  const CircularProgressIndicatorThemeData({@required this.data});

  final ThemeData data;

  Color get color => (data.brightness == Brightness.light)
      ? const Color(0xFF009BEB)
      : const Color(0xFF009BEB);
}

// https://material.io/tools/color/#!/?view.left=0&view.right=0&primary.color=E0E0E0&secondary.color=1565C0
// https://material.io/tools/color/#!/?view.left=0&view.right=0&primary.color=E0E0E0&secondary.color=218ae6
ThemeData buildTheme(Brightness brightness) {
  ThemeData base;
  if (brightness == Brightness.dark) {
    base = ThemeData.dark();
    base = base.copyWith(
      primaryColor: _darkPrimaryColor,
      primaryColorLight: _darkPrimaryColorLight,
      primaryColorDark: _darkPrimaryColorDark,
      accentColor: _darkSecondaryColor,
      textTheme: base.textTheme.copyWith(
        headline: TextStyle(
          color: _darkSecondaryColorDark,
        ),
        subtitle: TextStyle(
          color: _darkSecondaryColorDark,
        ),
        body1: TextStyle(
          color: _darkSecondaryColorDark,
        ),
        body2: TextStyle(
          color: _darkSecondaryColorDark,
        ),
        caption: const TextStyle(
          color: Colors.black,
        ),
      ),
      iconTheme: IconThemeData(
        color: _darkSecondaryColorDark,
      ),
      appBarTheme: AppBarTheme(
        brightness: brightness,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey[500],
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.grey[500],
        ),
        textTheme: TextTheme(
          headline: TextStyle(
            color: _darkSecondaryColorDark,
          ),
        ),
      ),
      // For showSearch().
      primaryIconTheme: IconThemeData(
        color: _darkSecondaryColorDark,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.pink,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFACD00),
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
      buttonColor: const Color(0xFFE60012),
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
