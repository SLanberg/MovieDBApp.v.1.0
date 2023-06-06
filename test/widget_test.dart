// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:sportsbet_task/ui/home_page.dart';
import 'package:sportsbet_task/widgets/custom_expansion_container.dart';

void main() {
  testWidgets('Check if movie containers are presented', (WidgetTester tester) async {
    // Build the Home widget
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Find the containers by their titles
    final latestMoviesFinder = find.byWidgetPredicate((widget) =>
    widget is CustomExpansionContainer && widget.title == 'Latest Movies');
    final popularMoviesFinder = find.byWidgetPredicate((widget) =>
    widget is CustomExpansionContainer && widget.title == 'Popular Movies');
    final topRatedMoviesFinder = find.byWidgetPredicate((widget) =>
    widget is CustomExpansionContainer && widget.title == 'Top Rated Movies');
    final upcomingMoviesFinder = find.byWidgetPredicate((widget) =>
    widget is CustomExpansionContainer && widget.title == 'Upcoming Movies');

    // Check if the containers are found
    expect(latestMoviesFinder, findsOneWidget);
    expect(popularMoviesFinder, findsOneWidget);
    expect(topRatedMoviesFinder, findsOneWidget);
    expect(upcomingMoviesFinder, findsOneWidget);
  });
}
