import 'package:flutter/material.dart';
import 'package:meekath/utils/enums.dart';

class AnimatedCheck extends StatelessWidget {
  final PayUploadStatus status;

  const AnimatedCheck({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == PayUploadStatus.loading) {
      return const Center(
          child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(strokeWidth: 7)));
    } else if (status == PayUploadStatus.success) {
      return const CheckMark(color: Colors.green, icon: Icons.check);
    } else if (status == PayUploadStatus.failed) {
      return const CheckMark(color: Colors.red,icon: Icons.close);
    } else {
      return const SizedBox();
    }
  }
}

class CheckMark extends StatefulWidget {
  final Color color;
  final IconData icon;

  const CheckMark({Key? key, required this.color, required this.icon})
      : super(key: key);

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
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: checkAnimation,
          axis: Axis.horizontal,
          axisAlignment: -1,
          child: Center(
            child: Icon(widget.icon, color: Colors.white, size: 100),
          ),
        ),
      ],
    );
  }
}
