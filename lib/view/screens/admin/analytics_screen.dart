import 'package:baitulmaal/utils/enums.dart';
import 'package:baitulmaal/view/widgets/logout_button.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/admin_view_model.dart';
import '../../animations/slide_in_widget.dart';
import '../../widgets/amount_percentage_indicator.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int meekath = Provider.of<PaymentProvider>(context, listen: false).meekath;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SlideInWidget(
                      delay: 100,
                      child: Text(
                        'Analytics ($meekath)',
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Refresh button
                  SlideInWidget(
                    delay: 1000,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Material(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: InkWell(
                            splashColor: Colors.white,
                            child: const Icon(Icons.refresh, color: Colors.white),
                            onTap: () async {
                              // Update all data's
                              AdminProvider provider = Provider.of<AdminProvider>(context, listen: false);
                              provider.showLoadingDialog(context, 'Updating...');
                              await provider.loadDataFromFirebase(context);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    AnalyticsSection(),
                    PaymentSection(),
                  ],
                ),
              ),
            ],
          ),

          // Logout button
          const SlideInWidget(
            delay: 1000,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: LogoutButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(builder: (ctx, provider, child) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideInWidget(
            delay: 1000,
            child: AmountPercentageIndicator(
              percentage: 1 - (provider.analytics.pendingAmount / provider.analytics.totalAmount),
              centerIconColor: Colors.black,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideInWidget(
                delay: 100,
                child: DetailsText(
                  text: 'Yearly Amount : ₹ ${provider.analytics.yearlyAmount}',
                ),
              ),
              SlideInWidget(
                delay: 200,
                child: DetailsText(
                  text: 'Total Amount : ₹ ${provider.analytics.totalAmount}',
                ),
              ),
              SlideInWidget(
                delay: 300,
                child: DetailsText(
                  text: 'Total Received : ₹ ${provider.analytics.totalReceivedAmount}',
                ),
              ),
              SlideInWidget(
                delay: 400,
                child: DetailsText(
                  text: 'Pending Amount : ₹ ${provider.analytics.pendingAmount}',
                ),
              ),
              SlideInWidget(
                delay: 500,
                child: DetailsText(
                  text: 'Extra Amount : ₹ ${(provider.analytics.extraAmount)}',
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class PaymentSection extends StatelessWidget {
  const PaymentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (ctx, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 10),
              child: SlideInWidget(
                delay: 600,
                child: Text(
                  'Payment details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SlideInWidget(
              delay: 700,
              child: DetailsText(
                text: 'Total Not verified amount : ₹ ${provider.getTotalAmount(PaymentStatus.notVerified)}',
              ),
            ),
            SlideInWidget(
              delay: 800,
              child: DetailsText(
                text: 'Total Accepted amount : ₹ ${provider.getTotalAmount(PaymentStatus.accepted)}',
              ),
            ),
            SlideInWidget(
              delay: 900,
              child: DetailsText(
                text: 'Total Rejected amount : ₹ ${provider.getTotalAmount(PaymentStatus.rejected)}',
              ),
            ),
          ],
        );
      },
    );
  }
}

class DetailsText extends StatelessWidget {
  final String text;

  const DetailsText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}
