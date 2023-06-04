// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:sportsbet_task/models/movie_model.dart';

class MovieRepository {
  Future<List<MovieModel>?> getMovieData(String url) async {
    final result = await http.Client().get(Uri.parse(url));
    if (result.statusCode != 200) {
      return null;
    } else {
      dynamic data = jsonDecode(result.body);
      List<MovieModel> movieModels = [];
      Iterable<dynamic> models = data['results'];
      for (var model in models) {
        MovieModel movieModel = MovieModel.fromJson(model);
        movieModels.add(movieModel);
      }

      return movieModels;
    }
  }
}
