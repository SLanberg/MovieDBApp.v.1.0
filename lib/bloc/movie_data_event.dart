part of 'movie_data_bloc.dart';

abstract class MovieDataEvent extends Equatable {
  const MovieDataEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieDataEvent extends MovieDataEvent {}

class LoadMovieDataOnExpandEvent extends MovieDataEvent {}