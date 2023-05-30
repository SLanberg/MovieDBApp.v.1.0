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
  final List<MovieModel>? topRatedApiResult;
  final List<MovieModel>? upcomingApiResult;


  const MovieDataLoadedState({
    required this.latestMoviesApiResult,
    required this.popularMoviesApiResult,
    this.topRatedApiResult,
    this.upcomingApiResult,

  });
}

class MovieDataErrorState extends MovieDataState {}