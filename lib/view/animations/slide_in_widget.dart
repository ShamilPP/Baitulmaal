import 'package:flutter/material.dart';

class SlideInWidget extends StatefulWidget {
  final Widget child;
  final int delay;
  final Duration duration;

  const SlideInWidget({
    Key? key,
    required this.child,
    this.delay = 100,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SlideInWidgetState();
}

class SlideInWidgetState extends State<SlideInWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;
  late Animation<Offset> animOffset;

  @override
  void dispose() {
    if (controller.isAnimating) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration);
    opacity = Tween<double>(begin: 0, end: 1).animate(controller);
    animOffset = Tween<Offset>(begin: const Offset(0, 0.8), end: Offset.zero).animate(controller);
    Future.delayed(Duration(milliseconds: widget.delay)).then(
          (value) {
        controller.forward();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animOffset,
      child: FadeTransition(
        opacity: opacity,
        child: widget.child,
      ),
    );
  }
}
