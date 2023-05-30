// Flutter imports:
import 'package:flutter/material.dart';

class CustomExpansionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const CustomExpansionContainer({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Colors.white,
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          textColor: Colors.black,
          collapsedTextColor: Colors.black,
          iconColor: Colors.black,
          collapsedIconColor: Colors.black,
          tilePadding: const EdgeInsets.only(left: 20.0, right: 15.0),
          childrenPadding: const EdgeInsets.only(left: 15.0, bottom: 20),
          title: Text(title),
          children: <Widget>[
            child,
          ],
        ),
      ),
    );
  }
}
