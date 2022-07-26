import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/utils/enums.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/admin_view_model.dart';
import '../animations/slide_in_widget.dart';

class PayScreen extends StatelessWidget {
  final UserModel user;
  final bool isAdmin;

  PayScreen({Key? key, required this.user, required this.isAdmin}) : super(key: key);

  final TextEditingController paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Consumer<PaymentProvider>(
            builder: (ctx, provider, child) {
              switch (provider.uploadStatus) {
                case Status.none:
                  return body(context);
                case Status.loading:
                  return const Center(
                      child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(strokeWidth: 7),
                  ));
                case Status.success:
                  return const AnimatedCheckMark(color: Colors.green, icon: Icons.check);
                case Status.failed:
                  return const AnimatedCheckMark(color: Colors.red, icon: Icons.close);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SlideAnimation(delay: 100, child: CloseButton()),
        Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //User details
                const SlideAnimation(
                  delay: 200,
                  child: Icon(
                    Icons.account_circle,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                SlideAnimation(
                  delay: 300,
                  child: Text(
                    "${user.name} paying",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                SlideAnimation(
                  delay: 400,
                  child: Text(
                    "+91 ${user.phoneNumber}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                // Meekath Dropdown (Change meekath year)
                isAdmin
                    ? SlideAnimation(
                        delay: 500,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Meekath  :  "),
                            meekathDropDown(),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 30),
                // Payment TextField
                SlideAnimation(delay: 500, child: PaymentTextField(controller: paymentController)),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        // Pay button
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideAnimation(
            delay: 800,
            child: SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'PAY',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  var provider = Provider.of<PaymentProvider>(context, listen: false);
                  provider.uploadPayment(context, paymentController.text, user, isAdmin);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget meekathDropDown() {
    return Consumer<PaymentProvider>(builder: (context, provider, child) {
      return DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: provider.meekath,
          items: provider.getMeekathList().map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value'),
            );
          }).toList(),
          onChanged: (newValue) async {
            provider.setMeekath(newValue!);
            await Provider.of<AdminProvider>(context, listen: false).loadDataFromFirebase(context);
          },
        ),
      );
    });
  }
}

class PaymentTextField extends StatelessWidget {
  final TextEditingController controller;

  const PaymentTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.blue.shade100.withOpacity(.8), borderRadius: BorderRadius.circular(10)),
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('₹', style: TextStyle(fontSize: 35)),
            const SizedBox(width: 8),
            IntrinsicWidth(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 35),
                decoration: const InputDecoration(
                  hintText: '000',
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedCheckMark extends StatefulWidget {
  final Color color;
  final IconData icon;

  const AnimatedCheckMark({Key? key, required this.color, required this.icon}) : super(key: key);

  @override
  _AnimatedCheckMarkState createState() => _AnimatedCheckMarkState();
}

class _AnimatedCheckMarkState extends State<AnimatedCheckMark> with TickerProviderStateMixin {
  late AnimationController scaleController =
      AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController =
      AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.linear);

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
