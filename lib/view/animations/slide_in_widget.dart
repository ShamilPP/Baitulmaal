import 'package:baitulmaal/utils/enums.dart';
import 'package:flutter/material.dart';

class SlideInWidget extends StatefulWidget {
  final Widget child;
  final SlidePosition position;
  final int delay;
  final Duration duration;

  const SlideInWidget({
    Key? key,
    required this.child,
    required this.position,
    this.delay = 100,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SlideInWidgetState();
}

class SlideInWidgetState extends State<SlideInWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

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
    offset = Tween<Offset>(begin: getOffset(widget.position), end: Offset.zero).animate(controller);
    Future.delayed(Duration(milliseconds: widget.delay)).then((value) {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offset,
      child: widget.child,
    );
  }

  Offset getOffset(SlidePosition position) {
    Offset offset = Offset.zero;
    if (position == SlidePosition.top) {
      offset = const Offset(0, -1);
    } else if (position == SlidePosition.bottom) {
      offset = const Offset(0, 1);
    } else if (position == SlidePosition.left) {
      offset = const Offset(-1, 0);
    } else if (position == SlidePosition.right) {
      offset = const Offset(1, 0);
    }
    return offset;
  }
}
