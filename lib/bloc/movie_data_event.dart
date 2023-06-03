part of 'movie_data_bloc.dart';

abstract class MovieDataEvent extends Equatable {
  const MovieDataEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieDataEvent extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class ScrollReachedEndLatestMovies extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class ScrollReachedEndPopularMovies extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class ScrollReachedEndTopRatedMovies extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class ScrollReachedEndUpcomingMovies extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class PullLatestMoviesEvent extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class TapOnLatestSection extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class TapOnTopRatedSectionEvent extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class TapOnUpcomingSectionEvent extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class OnErrorEvent extends MovieDataEvent {
  @override
  List<Object> get props => [];
}

class ClickToSeeMovieDetails extends MovieDataEvent {
  const ClickToSeeMovieDetails(this.movie_id);

  final int movie_id;

  @override
  List<Object> get props => [movie_id];
}

class TimeToChangePosterEvent extends MovieDataEvent {
  @override
  List<Object> get props => [];
}


class ClickOnButtonWithEvent extends MovieDataEvent {
  @override
  List<Object> get props => [];
}
