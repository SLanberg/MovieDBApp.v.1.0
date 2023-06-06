import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sportsbet_task/bloc/movie_data_bloc.dart';
import 'package:sportsbet_task/models/movie_model.dart';

import '../utils/date_utils.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage(
    this.context,
    this.imageIndex,
    this.apiResult,
    this.movieId,
  );
  final BuildContext context;
  final int imageIndex;
  final List<MovieModel> apiResult;
  final int? movieId;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    context
        .read<MovieDataBloc>()
        .add(ClickToSeeMovieDetails(widget.apiResult[widget.imageIndex].id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDataBloc, MovieDataState>(
      builder: (context, state) {
        if (state is MovieDetailsState) {
          return DraggableScrollableSheet(
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
                              child: widget.apiResult[widget.imageIndex]
                                          .posterPath !=
                                      null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          "http://image.tmdb.org/t/p/w500/${widget.apiResult[widget.imageIndex].posterPath}",
                                      height: 490,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'images/No-Image-Placeholder.png', // Replace with the path to your placeholder image in assets
                                      height: 490,
                                      fit: BoxFit.cover,
                                    ),
                            ),

                            ListTile(
                              leading: const Icon(Icons.info),
                              title: Text(
                                  '${widget.apiResult[widget.imageIndex].title}'),
                              onTap: () {
                                // Navigator.pop(context); // Close the bottom sheet
                                // Handle "View Details" action
                              },
                            ),

                            BlocBuilder<MovieDataBloc, MovieDataState>(
                              builder: (context, state) {
                                if (state is MovieDataInitialState) {
                                  // This CirculateProgress
                                  // you see while you waiting for data to load
                                  // and when even not triggered

                                  // TODO: Look in, maybe we don't need so many
                                  //  CircularProgressIndicators they handle in else block
                                  return const CircularProgressIndicator();
                                } else if (state is MovieDetailsState) {
                                  return ListTile(
                                      leading: const Icon(Icons.remove_red_eye),
                                      title: state.movieDetailsApiResult
                                          .status !=
                                          null
                                          ? Text(
                                          '${state.movieDetailsApiResult.status}')
                                          : null);
                                } else {
                                  // TODO: Look in, maybe we don't need so many
                                  //  CircularProgressIndicators they handle in else block
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),



                            ListTile(
                              leading: const Icon(Icons.calendar_month),
                              title: widget.apiResult[widget.imageIndex]
                                  .releaseDate !=
                                  null
                                  ? Text(formatDateWithSuffix(widget
                                  .apiResult[widget.imageIndex]
                                  .releaseDate!))
                                  : null,
                            ),

                            ListTile(
                                leading: const Icon(Icons.star_border),
                                title: widget.apiResult[widget.imageIndex]
                                    .voteAverage !=
                                    null
                                    ? Text(
                                    '${widget.apiResult[widget.imageIndex].voteAverage}')
                                    : null),

                            BlocBuilder<MovieDataBloc, MovieDataState>(
                              builder: (context, state) {
                                // TODO 2
                                print('state is: $state');
                                if (state is MovieDetailsState) {
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
                                    leading: const Icon(Icons.remove_red_eye),
                                    title: Text(
                                      'Unknown',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),

                            ListTile(
                                leading:
                                const Icon(Icons.contact_support_rounded),
                                title: widget.apiResult[widget.imageIndex]
                                    .overview !=
                                    null
                                    ? Text(
                                    '${widget.apiResult[widget.imageIndex].overview}')
                                    : null),

                            // In the response, if video is available show a play icon
                            // (use any free resource available).
                            // Clicking on this icon snackbar should appear with movie name.
                            ListTile(
                                leading: widget.apiResult[widget.imageIndex]
                                                .video !=
                                            null &&
                                        widget.apiResult[widget.imageIndex]
                                                .video !=
                                            false
                                    ? GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "${widget.apiResult[widget.imageIndex].title}",
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
          );
        } else {
          // This one you see if something went
          // wrong and your state is not the one you need
          return const SizedBox(
            height: 100,
            width: 10,
            child: Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}