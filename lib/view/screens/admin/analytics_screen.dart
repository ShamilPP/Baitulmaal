import 'package:baitulmaal/utils/enums.dart';
import 'package:baitulmaal/view/widgets/loading_widget.dart';
import 'package:baitulmaal/view/widgets/logout_button.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/admin_view_model.dart';
import '../../animations/slide_animation.dart';
import '../../widgets/amount_percentage_indicator.dart';
import '../../widgets/details_text.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AdminProvider>(builder: (ctx, provider, child) {
        if (provider.paymentStatus == Status.loading) {
          return const Center(child: LoadingWidget());
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  headerSection(context),
                  Padding(
                    padding: const EdgeInsets.only(left: 17, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        analyticsSection(provider),
                        paymentSection(provider),
                      ],
                    ),
                  ),
                ],
              ),

              // Logout button
              const SlideAnimation(
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
          );
        }
      }),
    );
  }

  Widget headerSection(BuildContext context) {
    int meekath = Provider.of<PaymentProvider>(context, listen: false).meekath;
    AdminProvider provider = Provider.of<AdminProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: SlideAnimation(
            delay: 100,
            child: Text(
              'Analytics ($meekath)',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // Refresh button
        SlideAnimation(
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
    );
  }

  Widget analyticsSection(AdminProvider provider) {
    var analytics = provider.analytics!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideAnimation(
          delay: 1000,
          child: AmountPercentageIndicator(
            percentage: 1 - (analytics.pendingAmount / analytics.totalAmount),
            centerIconColor: Colors.black,
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideAnimation(
              delay: 100,
              child: DetailsText(
                text: 'Yearly Amount : ₹ ${analytics.yearlyAmount}',
              ),
            ),
            SlideAnimation(
              delay: 200,
              child: DetailsText(
                text: 'Total Amount : ₹ ${analytics.totalAmount}',
              ),
            ),
            SlideAnimation(
              delay: 300,
              child: DetailsText(
                text: 'Total Received : ₹ ${analytics.totalReceivedAmount}',
              ),
            ),
            SlideAnimation(
              delay: 400,
              child: DetailsText(
                text: 'Pending Amount : ₹ ${analytics.pendingAmount}',
              ),
            ),
            SlideAnimation(
              delay: 500,
              child: DetailsText(
                text: 'Extra Amount : ₹ ${(analytics.extraAmount)}',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget paymentSection(AdminProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40, bottom: 10),
          child: SlideAnimation(
            delay: 600,
            child: Text(
              'Payment details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SlideAnimation(
          delay: 700,
          child: DetailsText(
            text: 'Total Not verified amount : ₹ ${provider.getTotalAmount(PaymentStatus.notVerified)}',
          ),
        ),
        SlideAnimation(
          delay: 800,
          child: DetailsText(
            text: 'Total Accepted amount : ₹ ${provider.getTotalAmount(PaymentStatus.accepted)}',
          ),
        ),
        SlideAnimation(
          delay: 900,
          child: DetailsText(
            text: 'Total Rejected amount : ₹ ${provider.getTotalAmount(PaymentStatus.rejected)}',
          ),
        ),
      ],
    );
  }
}
