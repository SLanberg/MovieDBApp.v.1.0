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
    on<MovieDataEvent>(
      (event, emit) async {
        if (event is LoadMovieDataEvent) {
          emit(MovieDataLoadingState());
          List<MovieModel>? apiResult = await movieRepository.getMovieData(
              "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1&api_key=${dotenv.env['API_KEY']}");
          List<MovieModel>? popularResult = await movieRepository.getMovieData(
              "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=${dotenv.env['API_KEY']}");

          if (apiResult == null ||
              popularResult == null) {
            emit(MovieDataErrorState());
          } else {
            emit(MovieDataLoadedState(
              latestMoviesApiResult: apiResult,
              popularMoviesApiResult: popularResult,
              topRatedApiResult: [],
              upcomingApiResult: [],
              isLatestMovieSectionExpanded: true,
              latestMoviesCurrentPage: 1,
              popularMoviesCurrentPage: 1,
              topRatedMoviesCurrentPage: 1,
              upcomingCurrentPage: 1,
            ));
          }
        }

      },
    );

    on<ScrollReachedEndLatestMovies>((event, emit) async {
      if (state is MovieDataLoadedState) {
        MovieDataLoadedState currentState = state as MovieDataLoadedState;

        try {

          int nextPageLatest = currentState.latestMoviesCurrentPage + 1;

          List<MovieModel>? apiResult = await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=$nextPageLatest&api_key=${dotenv.env['API_KEY']}",
          );

          if (apiResult != null) {
            List<MovieModel> updatedLatestMovies = [
              ...currentState.latestMoviesApiResult,
              ...apiResult
            ];
            emit(currentState.copyWith(
              latestMoviesApiResult: updatedLatestMovies,
              latestMoviesCurrentPage: nextPageLatest,
            ));
          }
        } catch (e) {
          emit(MovieDataErrorState());
        }
      }
    });

    on<ScrollReachedEndPopularMovies>((event, emit) async {
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
    });

    on<ScrollReachedEndTopRatedMovies>((event, emit) async {
      if (state is MovieDataLoadedState) {
        MovieDataLoadedState currentState = state as MovieDataLoadedState;

        try {
          int nextPageTopRated = currentState.topRatedMoviesCurrentPage + 1;
          List<MovieModel>? apiResultTopRated =
              await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=$nextPageTopRated&api_key=${dotenv.env['API_KEY']}",
          );

          if (apiResultTopRated != null) {
            List<MovieModel> updatedTopRatedMovies = [
              ...currentState.topRatedApiResult,
              ...apiResultTopRated
            ];
            emit(currentState.copyWith(
              topRatedApiResult: updatedTopRatedMovies,
              topRatedMoviesCurrentPage: nextPageTopRated,
            ));
          }
        } catch (e) {
          emit(MovieDataErrorState());
        }
      }
    });

    on<ScrollReachedEndUpcomingMovies>((event, emit) async {
      if (state is MovieDataLoadedState) {
        MovieDataLoadedState currentState = state as MovieDataLoadedState;

        try {
          int nextPageUpcoming = currentState.upcomingCurrentPage + 1;
          List<MovieModel>? apiResultUpcoming =
              await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=$nextPageUpcoming&api_key=${dotenv.env['API_KEY']}",
          );

          if (apiResultUpcoming != null) {
            List<MovieModel> updatedUpcomingMovies = [
              ...currentState.upcomingApiResult,
              ...apiResultUpcoming
            ];
            emit(currentState.copyWith(
              upcomingApiResult: updatedUpcomingMovies,
              upcomingCurrentPage: nextPageUpcoming,
            ));
          }
        } catch (e) {
          emit(MovieDataErrorState());
        }
      }
    });

    on<PullLatestMoviesEvent>((event, emit) async {
      if (state is MovieDataLoadedState) {
        MovieDataLoadedState currentState = state as MovieDataLoadedState;

        try {
          List<MovieModel>? apiResultLatest =
          await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=${currentState.latestMoviesCurrentPage}&api_key=${dotenv.env['API_KEY']}",
          );
          if (apiResultLatest != null) {
            // create a set of movie ids from the current state
            Set<int?> movieIds = currentState.latestMoviesApiResult
                .map((movie) => movie.id)
                .toSet();

            List<MovieModel> newMovies = apiResultLatest
                .where((movie) => !movieIds.contains(movie.id))
                .toList();

            List<MovieModel> updatedLatestMovies = [
              ...newMovies,
              ...currentState.latestMoviesApiResult
            ];
            emit(currentState.copyWith(
              latestMoviesApiResult: updatedLatestMovies,
            ));
          }
        } catch (e) {
          emit(MovieDataErrorState());
        }
      }
    });


    on<TapOnTopRatedSectionEvent>((event, emit) async {
      if (state is MovieDataLoadedState) {
        MovieDataLoadedState currentState = state as MovieDataLoadedState;

        List<MovieModel>? topRatedApiResult =
            await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1&api_key=${dotenv.env['API_KEY']}");

        if (topRatedApiResult != null) {
          emit(currentState.copyWith(
              topRatedApiResult: topRatedApiResult

          )
          );
        }
      }
    });


    on<TapOnUpcomingSectionEvent>((event, emit) async {
      if (state is MovieDataLoadedState) {
        MovieDataLoadedState currentState = state as MovieDataLoadedState;

        List<MovieModel>? upcomingApiResult =
            await movieRepository.getMovieData(
            "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1&api_key=${dotenv.env['API_KEY']}");

        if (upcomingApiResult != null) {
          emit(currentState.copyWith(
              upcomingApiResult: upcomingApiResult
          )
          );
        }
      }
    }) ;

    on<ClickToSeeMovieDetails>((event, emit) {
      print('this is Movie Details event');
    });
  }
}
