// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:sportsbet_task/bloc/movie_data_bloc.dart';
import 'package:sportsbet_task/models/movie_model.dart';
import '../widgets/custom_expansion_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollControllerLatest;

  late ScrollController _scrollControllerPopular;

  late ScrollController _scrollControllerTopRated;

  late ScrollController _scrollControllerUpcoming;

  Timer? movieTimer;
  Timer? posterTimer;

  bool latestMoviesExpanded = true;

  @override
  void initState() {
    super.initState();
    _setUpTimedMoviePull();
    _setUpTimedPosterChange();

    _scrollControllerLatest = ScrollController();
    _scrollControllerLatest.addListener(_onScroll);

    _scrollControllerPopular = ScrollController();
    _scrollControllerPopular.addListener(_onScroll);

    _scrollControllerTopRated = ScrollController();
    _scrollControllerTopRated.addListener(_onScroll);

    _scrollControllerUpcoming = ScrollController();
    _scrollControllerUpcoming.addListener(_onScroll);
  }

  _setUpTimedPosterChange() {
    posterTimer = Timer.periodic(const Duration(seconds: 90), (timer) {
      context.read<MovieDataBloc>().add(TimeToChangePosterEvent());
      if (kDebugMode) {
        print("Poster changed");
        print("Don't forget to make moving poster");
      }
    });
  }

  _setUpTimedMoviePull() {
    movieTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // I will set 60 seconds and will have changing screen every 60 seconds
      context.read<MovieDataBloc>().add(PullLatestMoviesEvent());
    });
  }

  // Stop the timer when CustomExpansionContainer is closed
  void stopMovieTimer() {
    movieTimer?.cancel();
  }

  void _onScroll() {
    if (_scrollControllerLatest.hasClients) {
      if (_scrollControllerLatest.position.atEdge &&
          _scrollControllerLatest.position.pixels > 0) {
        // Load more data when reaching the end of the scroll
        context.read<MovieDataBloc>().add(ScrollReachedEndLatestMovies());
      }
    }

    if (_scrollControllerPopular.hasClients) {
      if (_scrollControllerPopular.position.atEdge &&
          _scrollControllerPopular.position.pixels > 0) {
        // Load more data when reaching the end of the scroll
        context.read<MovieDataBloc>().add(ScrollReachedEndPopularMovies());
      }
    }

    if (_scrollControllerTopRated.hasClients) {
      if (_scrollControllerTopRated.position.atEdge &&
          _scrollControllerTopRated.position.pixels > 0) {
        // Load more data when reaching the end of the scroll
        context.read<MovieDataBloc>().add(ScrollReachedEndTopRatedMovies());
      }
    }

    if (_scrollControllerUpcoming.hasClients) {
      if (_scrollControllerUpcoming.position.atEdge &&
          _scrollControllerUpcoming.position.pixels > 0) {
        // Load more data when reaching the end of the scroll
        context.read<MovieDataBloc>().add(ScrollReachedEndUpcomingMovies());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MovieDataBloc, MovieDataState>(
        builder: (context, state) {
          if (state is MovieDataInitialState) {
            context.read<MovieDataBloc>().add(LoadMovieDataEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDataLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDataLoadedState) {
            return buildHomeSections(
                state.latestMoviesApiResult,
                state.popularMoviesApiResult,
                state.topRatedApiResult,
                state.upcomingApiResult);
          } else if (state is MovieDataErrorState) {
            // I need to stop to relay on MovieDB API so much
            // Instead of downloading specific Movie details
            // I should Iterate through the list of movies get their details
            // And store it in the list.
            debugPrint("⚠️ Something from API "
                "doesn't load up If you see this "
                "message it means you received error from API");

            context.read<MovieDataBloc>().add(LoadMovieDataEvent());
            return const CircularProgressIndicator();
          }

          return Center(
              child: Text(
            "We've got into undefined state. Chek the state parameter",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ));
        },
      ),
    );
  }

  Widget buildHomeSections(
    List<MovieModel> latestApiResult,
    List<MovieModel> popularApiResult,
    List<MovieModel> topRatedApiResult,
    List<MovieModel> upcomingApiResult,
  ) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: 550.0,

          // pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'http://image.tmdb.org/t/p/w500/${latestApiResult[Random().nextInt(latestApiResult.length)].posterPath}',
                  ),
                  // Replace with your image path
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              CustomExpansionContainer(
                  onExpansionChanged: (initiallyExpanded) {
                    if (!initiallyExpanded) {
                      stopMovieTimer();
                    } else {
                      _setUpTimedMoviePull();
                    }
                  },
                  initiallyExpanded: true,
                  title: 'Latest Movies',
                  child: _buildMovieList(
                    latestApiResult,
                    _scrollControllerLatest,
                  )),
              const SizedBox(
                height: 5.0,
              ),
              CustomExpansionContainer(
                  initiallyExpanded: true,
                  title: 'Popular Movies',
                  child: _buildMovieList(
                      popularApiResult, _scrollControllerPopular)),
              const SizedBox(
                height: 5.0,
              ),
              CustomExpansionContainer(
                  onExpansionChanged: (initiallyExpanded) {
                    if (initiallyExpanded) {
                      context
                          .read<MovieDataBloc>()
                          .add(TapOnTopRatedSectionEvent());
                    }
                  },
                  initiallyExpanded: false,
                  title: 'Top Rated Movies',
                  child: _buildMovieList(
                      topRatedApiResult, _scrollControllerTopRated)),
              const SizedBox(
                height: 5.0,
              ),
              CustomExpansionContainer(
                  onExpansionChanged: (initiallyExpanded) {
                    context
                        .read<MovieDataBloc>()
                        .add(TapOnUpcomingSectionEvent());
                  },
                  initiallyExpanded: false,
                  title: 'Upcoming Movies',
                  child: _buildMovieList(
                      upcomingApiResult, _scrollControllerUpcoming)),
            ],
          ),
        ),
      ],
    );
  }

  void _showImageDetails(
      BuildContext context, int imageIndex, List<MovieModel> apiResult) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (context) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.75,
              maxChildSize: 1,
              minChildSize: 0.50,
              builder: (context, scrollController) => Scaffold(
                body: Center(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: 350,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: apiResult[imageIndex].posterPath != null
                                    ? Image.network(
                                        "http://image.tmdb.org/t/p/w500/${apiResult[imageIndex].posterPath}",
                                        height: 490,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'images/No-Image-Placeholder.png', // Replace with the path to your placeholder image in assets
                                        height: 490,
                                        fit: BoxFit.cover,
                                      ),
                              ),

                              ClipRRect(
                                child: ListTile(
                                  leading: const Icon(Icons.info),
                                  title: Text('${apiResult[imageIndex].title}'),
                                  onTap: () {
                                    // Navigator.pop(context); // Close the bottom sheet
                                    // Handle "View Details" action
                                    _handleViewDetails(imageIndex, apiResult);
                                  },
                                ),
                              ),

                              BlocBuilder<MovieDataBloc, MovieDataState>(
                                builder: (context, state) {
                                  if (state is MovieDataInitialState) {
                                    return const CircularProgressIndicator();
                                  } else if (state is MovieDetailsState) {
                                    if (state.movieDetailsApiResult.genres !=
                                        null) {
                                      final genres =
                                          state.movieDetailsApiResult.genres;
                                      final genresString = genres != null
                                          ? genres
                                              .map((genre) => genre.name)
                                              .join(', ')
                                          : '';
                                      return ListTile(
                                        leading: const Icon(Icons.add_box),
                                        title: Text(
                                          genresString,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      );
                                    }
                                    return ListTile(
                                        leading:
                                            const Icon(Icons.remove_red_eye),
                                        title: Text(
                                          'Unknown',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ));
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),

                              ListTile(
                                  leading: const Icon(Icons.star_border),
                                  title: apiResult[imageIndex].voteAverage !=
                                          null
                                      ? Text(
                                          '${apiResult[imageIndex].voteAverage}')
                                      : null),

                              BlocBuilder<MovieDataBloc, MovieDataState>(
                                builder: (context, state) {
                                  context.read<MovieDataBloc>().add(
                                      ClickToSeeMovieDetails(
                                          apiResult[imageIndex].id!));

                                  if (state is MovieDataInitialState) {
                                    return const CircularProgressIndicator();
                                  } else if (state is MovieDetailsState) {
                                    return ListTile(
                                        leading:
                                            const Icon(Icons.remove_red_eye),
                                        title: state.movieDetailsApiResult
                                                    .status !=
                                                null
                                            ? Text(
                                                '${state.movieDetailsApiResult.status}')
                                            : null);
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),

                              ListTile(
                                leading: const Icon(Icons.calendar_month),
                                title: apiResult[imageIndex].releaseDate != null
                                    ? Text(DateFormat('yyyy-MM-dd').format(
                                        apiResult[imageIndex].releaseDate!))
                                    : null,
                              ),

                              ListTile(
                                  leading:
                                      const Icon(Icons.contact_support_rounded),
                                  title: apiResult[imageIndex].overview != null
                                      ? Text(
                                          '${apiResult[imageIndex].overview}')
                                      : null),

                              // In the response, if video is available show a play icon
                              // (use any free resource available).
                              // Clicking on this icon snackbar should appear with movie name.
                              ListTile(
                                  leading: apiResult[imageIndex].video !=
                                              null &&
                                          apiResult[imageIndex].video != false
                                      ? GestureDetector(
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${apiResult[imageIndex].title}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color: Colors.white),
                                                ),
                                                backgroundColor: Colors.green,
                                                duration:
                                                    const Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                          child: const Icon(Icons.play_arrow))
                                      : null),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 4.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 160,
              color: Colors.transparent,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // You can write more logic when user press on detail
  void _handleViewDetails(int imageIndex, List<MovieModel> apiResult) {
    // Replace with your logic to handle "View Details" action
    if (kDebugMode) {
      print('View Details for Image ${imageIndex + 1}');
    }
  }

  Widget _buildMovieList(
    List<MovieModel> movieList,
    ScrollController scrollController,
  ) {
    return SizedBox(
      height: 300.0,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: movieList.length,
        itemBuilder: (context, index) {
          if (index == movieList.length - 1) {
            return _buildLoadMoreIndicator();
          }

          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showImageDetails(context, index, movieList);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: movieList[index].posterPath != null
                          ? Image.network(
                              "http://image.tmdb.org/t/p/w500/${movieList[index].posterPath}",
                              width: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                    'images/No-Image-Placeholder.png');
                              },
                            )
                          : Image.asset(
                              'images/No-Image-Placeholder.png', // Replace with the path to your placeholder image in assets
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: 160,
                  height: 40,
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${movieList[index].title}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
