// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_data_bloc.dart';

class CustomExpansionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final event;

  const CustomExpansionContainer({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Colors.white,
        child: ExpansionTile(
          onExpansionChanged: (initiallyExpanded) {
            context.read<MovieDataBloc>().add(event);
          },
          initiallyExpanded: initiallyExpanded,
          textColor: Colors.black,
          collapsedTextColor: Colors.black,
          iconColor: Colors.black,
          collapsedIconColor: Colors.black,
          tilePadding: const EdgeInsets.only(left: 10.0, right: 15.0),
          childrenPadding: const EdgeInsets.only(left: 0.0, bottom: 20),
          title: Text(title),
          children: <Widget>[
            child,
          ],
        ),
      ),
    );
  }
}
