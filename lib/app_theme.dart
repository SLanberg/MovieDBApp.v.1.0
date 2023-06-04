// Flutter imports:
import 'package:flutter/material.dart';

// You can make different themes here,
// and store users choice with shared preferences
class AppTheme {
  static TextTheme originalTextTheme = const TextTheme(
    bodyMedium: TextStyle(
      fontFamily: "Roboto",
      fontSize: 14,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

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
