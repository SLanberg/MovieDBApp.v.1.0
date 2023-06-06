// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Project imports:
import 'package:sportsbet_task/repository/movie_detail_repository.dart';
import 'package:sportsbet_task/repository/movie_repository.dart';
import 'package:sportsbet_task/ui/home_page.dart';
import 'bloc/movie_data_bloc.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    BlocProvider<MovieDataBloc>(
      create: (context) =>
          MovieDataBloc(MovieRepository(), MovieDetailRepository()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieDB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: "Roboto",
            fontSize: 20,
            letterSpacing: 0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontFamily: "Roboto",
            fontSize: 14,
            letterSpacing: 0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        )
      ),

      home: MultiBlocProvider(
        providers: [
          BlocProvider<MovieDataBloc>(
            create: (context) =>
                MovieDataBloc(MovieRepository(), MovieDetailRepository()),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
