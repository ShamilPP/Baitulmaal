import 'package:flutter/material.dart';
import 'package:meekath/view/screens/user/profile_screen.dart';
import 'package:meekath/view/widgets/analytics_container.dart';
import 'package:meekath/view/widgets/payment_list.dart';
import 'package:meekath/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Consumer<UserProvider>(builder: (ctx, provider, child) {
            return Column(
              children: [
                Consumer<UserProvider>(builder: (context, provider, child) {
                  return AnalyticsContainer(
                    topLeftAmount: provider.user.monthlyPayment,
                    topLeftText: "Monthly payment",
                    topRightAmount:
                        provider.user.analytics!.totalReceivedAmount,
                    topRightText: " Paid amount",
                    bottomLeftAmount: provider.user.analytics!.pendingAmount,
                    bottomLeftText: "Pending amount",
                    bottomRightAmount: provider.user.analytics!.totalAmount,
                    bottomRightText: "Total amount",
                    showRupeeText: true,
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Payments",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Profile Icon
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        splashColor: Colors.black,
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.account_circle_outlined,
                            size: 30,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ProfileScreen(user: provider.user)));
                        },
                      ),
                    )
                  ],
                ),
                Consumer<UserProvider>(builder: (ctx, provider, child) {
                  return Expanded(
                    child: PaymentList(
                      paymentList: provider.userPaymentList,
                      ifAdmin: false,
                    ),
                  );
                })
              ],
            );
          }),
        ),
      ),
    );
  }
}
