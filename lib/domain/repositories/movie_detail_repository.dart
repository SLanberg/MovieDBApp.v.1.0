// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import '../../domain/models/movie_detail_model.dart';

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
