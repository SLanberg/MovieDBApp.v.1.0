import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sportsbet_task/models/movie_model.dart';
import 'package:sportsbet_task/repository/movie_repository.dart';
import 'package:equatable/equatable.dart';

part 'movie_data_event.dart';
part 'movie_data_state.dart';

class MovieDataBloc extends Bloc<MovieDataEvent, MovieDataState> {
  final MovieRepository movieRepository;

  MovieDataBloc(
    this.movieRepository,
  ) : super(MovieDataInitialState()) {
    on<MovieDataEvent>((event, emit) async {
      if (event is LoadMovieDataEvent) {
        emit(MovieDataLoadingState());
        List<MovieModel>? apiResult = await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1&api_key=${dotenv.env['API_KEY']}");
        List<MovieModel>? popularResult = await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=${dotenv.env['API_KEY']}");
        List<MovieModel>? topRatedApiResult = await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1&api_key=${dotenv.env['API_KEY']}");
        List<MovieModel>? upcomingApiResult = await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1&api_key=${dotenv.env['API_KEY']}");

        if (apiResult == null ||
            popularResult == null ||
            topRatedApiResult == null ||
            upcomingApiResult == null) {
          emit(MovieDataErrorState());
        } else {
          emit(MovieDataLoadedState(
            latestMoviesApiResult: apiResult,
            popularMoviesApiResult: popularResult,
            topRatedApiResult: topRatedApiResult,
            upcomingApiResult: upcomingApiResult,
            latestMoviesCurrentPage: 1,
            popularMoviesCurrentPage: 1,
            topRatedMoviesCurrentPage: 1,
            upcomingCurrentPage: 1,
          ));
        }
      }

      if (event is ScrollReachedEndLatestMovies) {
        if (state is MovieDataLoadedState) {
          MovieDataLoadedState currentState = state as MovieDataLoadedState;

          try {
            int nextPage = currentState.latestMoviesCurrentPage + 1;
            List<MovieModel>? apiResult = await movieRepository.getMovieData(
              "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=$nextPage&api_key=${dotenv.env['API_KEY']}",
            );

            if (apiResult != null) {
              List<MovieModel> updatedLatestMovies = [
                ...currentState.latestMoviesApiResult,
                ...apiResult
              ];
              emit(currentState.copyWith(
                latestMoviesApiResult: updatedLatestMovies,
                latestMoviesCurrentPage: nextPage,
              ));
            }
          } catch (e) {
            emit(MovieDataErrorState());
          }
        }
      }

      if (event is ScrollReachedEndPopularMovies) {
        if (state is MovieDataLoadedState) {
          MovieDataLoadedState currentState = state as MovieDataLoadedState;

          try {
            int nextPagePopular = currentState.popularMoviesCurrentPage + 1;
            List<MovieModel>? apiResultPopular =
                await movieRepository.getMovieData(
              "https://api.themoviedb.org/3/movie/popular?language=en-US&page=$nextPagePopular&api_key=${dotenv.env['API_KEY']}",
            );

            if (apiResultPopular != null) {
              List<MovieModel> updatedPopularMovies = [
                ...currentState.popularMoviesApiResult,
                ...apiResultPopular
              ];
              emit(currentState.copyWith(
                popularMoviesApiResult: updatedPopularMovies,
                popularMoviesCurrentPage: nextPagePopular,
              ));
            }
          } catch (e) {
            emit(MovieDataErrorState());
          }
        }
      }

      if (event is ScrollReachedEndTopRatedMovies) {
        if (state is MovieDataLoadedState) {
          MovieDataLoadedState currentState = state as MovieDataLoadedState;

          try {
            int nextPage = currentState.topRatedMoviesCurrentPage + 1;
            List<MovieModel>? apiResultTopRated =
                await movieRepository.getMovieData(
              "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=$nextPage&api_key=${dotenv.env['API_KEY']}",
            );

            if (apiResultTopRated != null) {
              List<MovieModel> updatedTopRatedMovies = [
                ...currentState.topRatedApiResult,
                ...apiResultTopRated
              ];
              emit(currentState.copyWith(
                topRatedApiResult: updatedTopRatedMovies,
                topRatedMoviesCurrentPage: nextPage,
              ));
            }
          } catch (e) {
            emit(MovieDataErrorState());
          }
        }
      }

      if (event is ScrollReachedEndUpcomingMovies) {
        if (state is MovieDataLoadedState) {
          MovieDataLoadedState currentState = state as MovieDataLoadedState;

          try {
            int nextPage = currentState.upcomingCurrentPage + 1;
            List<MovieModel>? apiResultUpcoming =
                await movieRepository.getMovieData(
              "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=$nextPage&api_key=${dotenv.env['API_KEY']}",
            );

            if (apiResultUpcoming != null) {
              List<MovieModel> updatedUpcomingMovies = [
                ...currentState.upcomingApiResult,
                ...apiResultUpcoming
              ];
              emit(currentState.copyWith(
                upcomingApiResult: updatedUpcomingMovies,
                upcomingCurrentPage: nextPage,
              ));
            }
          } catch (e) {
            emit(MovieDataErrorState());
          }
        }
      }
    });
  }
}
