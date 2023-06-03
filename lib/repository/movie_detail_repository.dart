import 'dart:convert';

import 'package:sportsbet_task/models/movie_detail_model.dart';
import 'package:http/http.dart' as http;

class MovieDetailRepository {
  Future<MovieDetailModel?> getMovieDetail(String url) async {
    final result = await http.Client().get(Uri.parse(url));
    if (result.statusCode != 200) {
      return null;
    } else {
      dynamic data = jsonDecode(result.body);
      MovieDetailModel movieDetailModel = MovieDetailModel.fromJson(data);
      return movieDetailModel;
    }
  }
}