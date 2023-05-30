part of 'movie_data_bloc.dart';

abstract class MovieDataState extends Equatable {
  const MovieDataState();

  @override
  List<Object> get props => [];
}

class MovieDataInitialState extends MovieDataState {}

class MovieDataLoadingState extends MovieDataState {}

class MovieDataLoadedState extends MovieDataState {
  final List<MovieModel> latestMoviesApiResult;
  final List<MovieModel> popularMoviesApiResult;
  final List<MovieModel> topRatedApiResult;
  final List<MovieModel> upcomingApiResult;
  final int latestMoviesCurrentPage;
  final int popularMoviesCurrentPage;
  final int topRatedMoviesCurrentPage;
  final int upcomingCurrentPage;

  MovieDataLoadedState({
    required this.latestMoviesApiResult,
    required this.popularMoviesApiResult,
    required this.topRatedApiResult,
    required this.upcomingApiResult,
    required this.latestMoviesCurrentPage,
    required this.popularMoviesCurrentPage,
    required this.topRatedMoviesCurrentPage,
    required this.upcomingCurrentPage,
  });

  MovieDataLoadedState copyWith({
    List<MovieModel>? latestMoviesApiResult,
    List<MovieModel>? popularMoviesApiResult,
    List<MovieModel>? topRatedApiResult,
    List<MovieModel>? upcomingApiResult,
    int? latestMoviesCurrentPage,
    int? popularMoviesCurrentPage,
    int? topRatedMoviesCurrentPage,
    int? upcomingCurrentPage,
  }) {
    return MovieDataLoadedState(
      latestMoviesApiResult: latestMoviesApiResult ?? this.latestMoviesApiResult,
      popularMoviesApiResult: popularMoviesApiResult ?? this.popularMoviesApiResult,
      topRatedApiResult: topRatedApiResult ?? this.topRatedApiResult,
      upcomingApiResult: upcomingApiResult ?? this.upcomingApiResult,
      latestMoviesCurrentPage: latestMoviesCurrentPage ?? this.latestMoviesCurrentPage,
      popularMoviesCurrentPage: popularMoviesCurrentPage ?? this.popularMoviesCurrentPage,
      topRatedMoviesCurrentPage: topRatedMoviesCurrentPage ?? this.topRatedMoviesCurrentPage,
      upcomingCurrentPage: upcomingCurrentPage ?? this.upcomingCurrentPage,
    );
  }

  @override
  List<Object> get props => [
    latestMoviesApiResult,
    popularMoviesApiResult,
    topRatedApiResult,
    upcomingApiResult,
    latestMoviesCurrentPage,
    popularMoviesCurrentPage,
    topRatedMoviesCurrentPage,
    upcomingCurrentPage,
  ];
}


class MovieDataErrorState extends MovieDataState {}
