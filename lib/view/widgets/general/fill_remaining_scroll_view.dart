import 'package:flutter/material.dart';

class FillRemainingScrollView extends StatelessWidget {
  final Widget child;

  const FillRemainingScrollView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: child,
        ),
      ],
    );
  }
}
