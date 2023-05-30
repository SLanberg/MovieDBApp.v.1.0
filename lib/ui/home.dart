import 'package:flutter/foundation.dart';
import 'package:sportsbet_task/bloc/movie_data_bloc.dart';
import 'package:sportsbet_task/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_expansion_container.dart';
import 'package:intl/intl.dart';

import 'dart:math';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MovieDataBloc, MovieDataState>(
        builder: (context, state) {
          // context.read<GameDataBloc>().add(GameDataLoading());
          if (state is MovieDataInitialState) {
            context.read<MovieDataBloc>().add(LoadMovieDataEvent());
            return const CircularProgressIndicator();
          } else if (state is MovieDataLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDataLoadedState) {
            return buildGameModel(
                state.latestMoviesApiResult,
                state.popularMoviesApiResult,
                state.topRatedApiResult,
                state.upcomingApiResult);
          } else if (state is MovieDataErrorState) {
            return const Center(
              child: Text("Uh oh! 😭 Something went wrong!"),
            );
          }
          return const Text("Error");
        },
      ),
    );
  }

  Widget buildGameModel(
    List<MovieModel> apiResult,
    List<MovieModel> popularResult,
    List<MovieModel>? topRatedApiResult,
    List<MovieModel>? upcomingApiResult,
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
                      'http://image.tmdb.org/t/p/w500/${apiResult[Random().nextInt(apiResult.length)].posterPath}'),
                  // Replace with your image path
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // title: Text('Available seats'),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              CustomExpansionContainer(
                initiallyExpanded: true,
                title: 'Latest Movies',
                child: SizedBox(
                  height: 300.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: apiResult.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _showImageDetails(context, index, apiResult);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    "http://image.tmdb.org/t/p/w500/${apiResult[index].posterPath}",
                                    width: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              width: 160,
                              height:
                                  40, // Increase the height to make the container higher
                              alignment: Alignment
                                  .topLeft, // Align the text at the top left
                              child: Text(
                                '${apiResult[index].originalTitle}',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign
                                    .start, // Align the text at the start (left)
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              CustomExpansionContainer(
                initiallyExpanded: true,
                title: 'Popular Movies',
                child: SizedBox(
                  height: 300.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: apiResult.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _showImageDetails(
                                      context, index, popularResult);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    "http://image.tmdb.org/t/p/w500/${popularResult[index].posterPath}",
                                    width: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              width: 160,
                              height:
                                  40, // Increase the height to make the container higher
                              alignment: Alignment
                                  .topLeft, // Align the text at the top left
                              child: Text(
                                '${apiResult[index].originalTitle}',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign
                                    .start, // Align the text at the start (left)
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              CustomExpansionContainer(
                title: 'Top Rated Movies',
                child: SizedBox(
                  height: 300.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: apiResult.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (topRatedApiResult != null) {
                                    _showImageDetails(
                                        context, index, topRatedApiResult);
                                  }
                                  },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    "http://image.tmdb.org/t/p/w500/${topRatedApiResult?[index].posterPath}",
                                    width: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              width: 160,
                              height:
                                  40, // Increase the height to make the container higher
                              alignment: Alignment
                                  .topLeft, // Align the text at the top left
                              child: Text(
                                '${topRatedApiResult?[index].originalTitle}',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign
                                    .start, // Align the text at the start (left)
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              CustomExpansionContainer(
                title: 'Upcoming Movies',
                child: SizedBox(
                  height: 300.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: apiResult.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (upcomingApiResult != null) {
                                    // _showImageDetails(
                                    //     context, index, upcomingApiResult);

                                    _showImageDetails(context, index, upcomingApiResult);
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    "http://image.tmdb.org/t/p/w500/${upcomingApiResult?[index].posterPath}",
                                    width: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              width: 160,
                              height:
                                  40, // Increase the height to make the container higher
                              alignment: Alignment
                                  .topLeft, // Align the text at the top left
                              child: Text(
                                '${upcomingApiResult?[index].originalTitle}',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign
                                    .start, // Align the text at the start (left)
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImageDetails(BuildContext context, int imageIndex, List<MovieModel> apiResult) {
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),

        ),
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.75,
          minChildSize: 0.32,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0,),

                SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'http://image.tmdb.org/t/p/w500/${apiResult[imageIndex].posterPath}',
                          height: 500,
                          fit: BoxFit.fill,
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

                      ListTile(
                        leading: const Icon(Icons.calendar_month),
                        title: apiResult[imageIndex].releaseDate != null
                            ? Text(DateFormat('yyyy-MM-dd')
                            .format(apiResult[imageIndex].releaseDate!))
                            : null,
                        onTap: () {
                          // Navigator.pop(context); // Close the bottom sheet
                          // Handle "View Details" action
                          _handleViewDetails(imageIndex, apiResult);
                        },
                      ),
                      ListTile(
                          leading: const Icon(Icons.contact_support_rounded),
                          title: apiResult[imageIndex].overview != null
                              ? Text('${apiResult[imageIndex].overview}')
                              : null),

                      // In the response, if video is available show a play icon
                      // (use any free resource available).
                      // Clicking on this icon snackbar should appear with movie name.
                      ListTile(
                          leading: apiResult[imageIndex].video != null &&
                              apiResult[imageIndex].video != false
                              ? const Icon(Icons.play_arrow)
                              : null),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  // You can write more logic when user press on detail
  void _handleViewDetails(int imageIndex, List<MovieModel> apiResult) {
    // Replace with your logic to handle "View Details" action
    if (kDebugMode) {
      print('View Details for Image ${imageIndex + 1}');
    }
  }
}
