import 'package:baitulmaal/view/animations/slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListCard extends StatelessWidget {
  final String name;
  final String? subText;
  final Color? subColor;
  final void Function()? onTap;
  final String suffixText;

  const ListCard({
    Key? key,
    required this.name,
    required this.subText,
    this.subColor = Colors.black,
    required this.onTap,
    this.suffixText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SlideAnimation(
                      delay: 100,
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    subText == null
                        ? loadingAnimationForText()
                        : SlideAnimation(
                            delay: 300,
                            child: Text(
                              subText!,
                              style: TextStyle(fontSize: 15, color: subColor),
                            ),
                          ),
                  ],
                ),
                SlideAnimation(child: Text(suffixText))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadingAnimationForText() {
    return SizedBox(
      child: SpinKitWave(
        size: 20,
        itemBuilder: (ctx, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
