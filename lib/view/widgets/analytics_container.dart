import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../animations/slide_in_widget.dart';
import 'amount_percentage_indicator.dart';

class AnalyticsContainer extends StatelessWidget {
  final int topLeftAmount;
  final String topLeftText;
  final int topRightAmount;
  final String topRightText;
  final int bottomLeftAmount;
  final String bottomLeftText;
  final int bottomRightAmount;
  final String bottomRightText;
  final bool showRupeeText;

  const AnalyticsContainer({
    Key? key,
    required this.topLeftAmount,
    required this.topLeftText,
    required this.topRightAmount,
    required this.topRightText,
    required this.bottomLeftAmount,
    required this.bottomLeftText,
    required this.bottomRightAmount,
    required this.bottomRightText,
    this.showRupeeText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: primaryColor.withAlpha(70), blurRadius: 20, offset: const Offset(0, 10))]),
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
              child: AnalyticsText(
                mainText: (showRupeeText ? '₹ ' : '') + '$topLeftAmount',
                subText: topLeftText,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: AnalyticsText(
                mainText: (showRupeeText ? '₹ ' : '') + '$topRightAmount',
                subText: topRightText,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: AnalyticsText(
                mainText: '₹ $bottomLeftAmount',
                subText: bottomLeftText,
                color: Colors.red,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: AnalyticsText(
                mainText: '₹ $bottomRightAmount',
                subText: bottomRightText,
              ),
            ),
            Center(
              child: AmountPercentageIndicator(percentage: 1 - (bottomLeftAmount / bottomRightAmount)),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsText extends StatelessWidget {
  final String mainText;
  final String subText;
  final Color color;

  const AnalyticsText({
    Key? key,
    required this.mainText,
    required this.subText,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideInWidget(
          delay: 200,
          child: Text(
            mainText,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        SlideInWidget(
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
