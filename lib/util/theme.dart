import 'package:flutter/material.dart';

const Color lightBlueColor = Color(0xFF218AE6);
const Color darkBlueColor = Color(0xFF005EB3);
const Color redColor = Color(0xFFE60012);
const Color greenColor = Color(0xFF44B035);
final Color lightGrey = Colors.grey[300];
final Color darkGrey = Colors.grey[600];

class ActionBarThemeData {
  const ActionBarThemeData({@required this.data});

  final ThemeData data;

  Color get color => lightBlueColor;

  Color get iconColor => lightBlueColor;

  Color get selectedItemColor => darkBlueColor;

  Color get selectedItemBackgroundColor => (data.brightness == Brightness.light)
      ? Colors.blue[50]
      : Colors.blue[100];
}

class ItemCardThemeData {
  const ItemCardThemeData({@required this.data});

  final ThemeData data;

  Color get color => Colors.white;

  Color get backgroundColor => Colors.blue[50];

  Color get shadowColor => (data.brightness == Brightness.light)
      ? Colors.grey[300]
      : Colors.grey[600];

  Color get saturationColor => Colors.blue[50];

  Color get ownedColor => const Color(0xFFE60012);

  Color get missedColor => const Color(0xFF44B035);
}

class BottomNavBarThemeData {
  const BottomNavBarThemeData({@required this.data});

  final ThemeData data;

  Color get selectedItemColor => lightBlueColor;

  Color get unselectedItemColor => Colors.grey[500];
}

class CircularProgressIndicatorThemeData {
  const CircularProgressIndicatorThemeData({@required this.data});

  final ThemeData data;

  // WebView.
  Color get color => lightBlueColor;
}

ThemeData buildTheme(Brightness brightness) {
  ThemeData base;
  if (brightness == Brightness.dark) {
    base = ThemeData.dark();
    base = base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: lightBlueColor,
        primaryVariant: darkBlueColor,
        secondary: lightBlueColor,
        secondaryVariant: darkBlueColor,
      ),
      // Radio buttons (Settings page).
      toggleableActiveColor: lightBlueColor,
      // Appbar and drawer icons.
      iconTheme: const IconThemeData(
        color: lightBlueColor,
      ),
      // WebView icons.
      primaryIconTheme: const IconThemeData(
        color: lightBlueColor,
      ), // Buttons of showAboutDialog.
      buttonTheme: ButtonThemeData(
        buttonColor: lightBlueColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
      ),
    );
  } else {
    base = ThemeData.light();
    base = base.copyWith(
      colorScheme: ColorScheme.light(
        primary: lightBlueColor,
        primaryVariant: darkBlueColor,
        secondary: lightBlueColor,
        secondaryVariant: darkBlueColor,
      ),
      appBarTheme: const AppBarTheme(
        brightness: Brightness.light,
        color: Colors.white,
        elevation: 2.0,
        iconTheme: IconThemeData(color: lightBlueColor),
        actionsIconTheme: IconThemeData(color: lightBlueColor),
        textTheme: TextTheme(
          title: TextStyle(color: Colors.black, fontSize: 18.0),
          headline: TextStyle(color: Colors.black),
        ),
      ),
      // Radio buttons (Settings page).
      toggleableActiveColor: lightBlueColor,
      // Appbar and drawer icons.
      iconTheme: const IconThemeData(
        color: lightBlueColor,
      ),
      // WebView icons.
      primaryIconTheme: const IconThemeData(
        color: lightBlueColor,
      ), // Buttons of showAboutDialog.
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        buttonColor: lightBlueColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
      ),
    );
  }
  return base;
}
