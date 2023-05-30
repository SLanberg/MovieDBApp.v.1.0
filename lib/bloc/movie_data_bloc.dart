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
              List<MovieModel> updatedLatestMovies = [...currentState.latestMoviesApiResult, ...apiResult];
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

      }

      if (event is ScrollReachedEndTopRatedMovies) {

      }

      if (event is ScrollReachedEndUpcomingMovies) {

      }




    });
  }
}
