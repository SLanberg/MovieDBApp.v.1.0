// Flutter imports:
import 'package:flutter/material.dart';

// You can make different themes here,
// and store users choice with shared preferences
class AppTheme {
  static TextTheme originalTextTheme = const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: "Roboto",
        fontSize: 41,
        height: 1,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Roboto",
        fontSize: 30,
        height: 1,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontFamily: "Roboto",
        fontSize: 24,
        height: 1,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      // headlineSmall: ,
      titleMedium: TextStyle(
        fontFamily: "Roboto",
        fontSize: 20,
        height: 1,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Roboto",
        fontSize: 14,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontFamily: "Roboto",
        fontSize: 12,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      labelSmall: TextStyle(
        fontFamily: "Roboto",
        fontStyle: FontStyle.italic,
        fontSize: 12,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ));

  static ThemeData original() {
    return ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(2, 31, 82, 1),
      appBarTheme: const AppBarTheme(color: Color.fromRGBO(2, 31, 82, 1)),
      bottomAppBarColor: const Color.fromRGBO(2, 31, 82, 1),
      primaryColor: const Color.fromRGBO(2, 31, 82, 1),
      brightness: Brightness.light,
      textTheme: originalTextTheme,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values)
            platform: const NoTransitionsBuilder(),
        },
      ),
    );
  }
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    // only return the child without warping it with animations
    return child!;
  }
}
