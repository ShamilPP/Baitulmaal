import 'package:flutter/material.dart';

class AnimatedCheck extends StatelessWidget {
  final bool isLoading;

  const AnimatedCheck({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(strokeWidth: 7)))
        : const CheckMark();
  }
}

class CheckMark extends StatefulWidget {
  const CheckMark({Key? key}) : super(key: key);

  @override
  _CheckMarkState createState() => _CheckMarkState();
}

class _CheckMarkState extends State<CheckMark> with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(
      duration: const Duration(milliseconds: 800), vsync: this);
  late Animation<double> scaleAnimation =
      CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(
      duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> checkAnimation =
      CurvedAnimation(parent: checkController, curve: Curves.linear);

  @override
  void initState() {
    super.initState();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              height: 140,
              width: 140,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: checkAnimation,
          axis: Axis.horizontal,
          axisAlignment: -1,
          child: const Center(
            child: Icon(Icons.check, color: Colors.white, size: 100),
          ),
        ),
      ],
    );
  }
}
