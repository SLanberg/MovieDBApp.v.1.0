// Flutter imports:
import 'package:flutter/material.dart';

class CustomExpansionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const CustomExpansionContainer({
    Key? key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Colors.white,
        child: ExpansionTile(
          onExpansionChanged: onExpansionChanged,
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
