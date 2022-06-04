import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AmountPercentageIndicator extends StatelessWidget {
  final double percentage;
  final Color centerIconColor;

  const AmountPercentageIndicator({
    Key? key,
    required this.percentage,
    this.centerIconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 55,
      lineWidth: 10,
      percent: percentage,
      animation: true,
      animationDuration: 1000,
      center: Icon(
        Icons.currency_rupee,
        color: centerIconColor,
        size: 30,
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.green,
      backgroundColor: Colors.grey.shade300,
    );
  }
}
