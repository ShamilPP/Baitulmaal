import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../animations/slide_animation.dart';
import 'amount_percentage_indicator.dart';

class AnalyticsCard extends StatelessWidget {
  final double percentage;
  final String topLeftAmount;
  final String topLeftText;
  final String topRightAmount;
  final String topRightText;
  final String bottomLeftAmount;
  final String bottomLeftText;
  final String bottomRightAmount;
  final String bottomRightText;

  const AnalyticsCard({
    Key? key,
    required this.percentage,
    required this.topLeftAmount,
    required this.topLeftText,
    required this.topRightAmount,
    required this.topRightText,
    required this.bottomLeftAmount,
    required this.bottomLeftText,
    required this.bottomRightAmount,
    required this.bottomRightText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: primaryColor.withAlpha(70), blurRadius: 20, offset: const Offset(0, 10))
      ]),
      child: Container(
        padding: const EdgeInsets.all(13),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: _AnalyticsText(
                mainText: topLeftAmount,
                subText: topLeftText,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _AnalyticsText(
                mainText: topRightAmount,
                subText: topRightText,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: _AnalyticsText(
                mainText: bottomLeftAmount,
                subText: bottomLeftText,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _AnalyticsText(
                mainText: bottomRightAmount,
                subText: bottomRightText,
                color: Colors.red,
              ),
            ),
            Center(
              child: AmountPercentageIndicator(percentage: percentage),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsText extends StatelessWidget {
  final String mainText;
  final String subText;
  final Color color;

  const _AnalyticsText({
    Key? key,
    required this.mainText,
    required this.subText,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideAnimation(
          delay: 200,
          child: Text(
            mainText,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        SlideAnimation(
          delay: 500,
          child: Text(
            subText,
            style: TextStyle(fontSize: 13, color: color),
          ),
        ),
      ],
    );
  }
}
