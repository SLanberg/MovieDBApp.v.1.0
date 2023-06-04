// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:sportsbet_task/bloc/movie_data_bloc.dart';
import 'package:sportsbet_task/models/movie_model.dart';
import '../widgets/custom_expansion_container.dart';
import 'detail_page.dart';

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
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget != oldWidget) {
      print('Not equal');
    }
  }

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
      if (kDebugMode) {}
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
              state.upcomingApiResult,
              state.homePageHeroPoster,
            );
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
      String? homePageHeroPoster,
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
                  image: CachedNetworkImageProvider(
                    'http://image.tmdb.org/t/p/w500/$homePageHeroPoster',
                  ),
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

  void _showImageDetails(BuildContext context, int imageIndex,
      List<MovieModel> apiResult, int? movieId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return DetailsPage(context, imageIndex, apiResult, movieId);
        });
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
      print('Make a copy for ${imageIndex + 1} post release feature');
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
                      _showImageDetails(
                          context, index, movieList, movieList[index].id);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: movieList[index].posterPath != null
                          ? CachedNetworkImage(
                        imageUrl:
                        "http://image.tmdb.org/t/p/w500/${movieList[index].posterPath}",
                        width: 180,
                        fit: BoxFit.cover,
                        errorWidget: (BuildContext context, String url,
                            dynamic error) {
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
