part of 'movie_data_bloc.dart';

abstract class MovieDataEvent extends Equatable {
  const MovieDataEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieDataEvent extends MovieDataEvent {}

class LoadMovieDataOnExpandEvent extends MovieDataEvent {}

class ScrollReachedEndLatestMovies extends MovieDataEvent {}

class ScrollReachedEndPopularMovies extends MovieDataEvent {}

class ScrollReachedEndTopRatedMovies extends MovieDataEvent {}

class ScrollReachedEndUpcomingMovies extends MovieDataEvent {}

class PullLatestMoviesEvent extends MovieDataEvent {}

class OnErrorEvent extends MovieDataEvent {}

