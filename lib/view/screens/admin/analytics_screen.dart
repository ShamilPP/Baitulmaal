import 'package:baitulmaal/utils/enums.dart';
import 'package:baitulmaal/view/widgets/logout_button.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/admin_overview_model.dart';
import '../../../view_model/admin_view_model.dart';
import '../../animations/slide_in_widget.dart';
import '../../widgets/amount_percentage_indicator.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: SlideInWidget(
                      delay: 200,
                      child: Text(
                        'Analytics',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Refresh button
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SlideInWidget(
                      delay: 2400,
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
                              Provider.of<PaymentProvider>(context, listen: false)
                                  .showLoadingDialog(context, 'Updating...');
                              await provider.initData(context);
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
                  children: [
                    Consumer<AdminProvider>(
                      builder: (ctx, provider, child) {
                        AdminOverviewModel adminOverview = provider.getAdminOverview();
                        return AnalyticsSection(adminOverview: adminOverview);
                      },
                    ),
                    const PaymentSection(),
                  ],
                ),
              ),
            ],
          ),

          // Logout button
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: SlideInWidget(delay: 2200, child: LogoutButton()),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsSection extends StatelessWidget {
  final AdminOverviewModel adminOverview;

  const AnalyticsSection({Key? key, required this.adminOverview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideInWidget(
          delay: 2000,
          child: AmountPercentageIndicator(
            percentage: 1 - (adminOverview.pendingAmount / adminOverview.totalAmount),
            centerIconColor: Colors.black,
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideInWidget(
              delay: 400,
              child: DetailsText(
                text: 'Total Amount : ₹ ${adminOverview.totalAmount}',
              ),
            ),
            SlideInWidget(
              delay: 600,
              child: DetailsText(
                text: 'Total Received : ₹ ${adminOverview.totalReceivedAmount}',
              ),
            ),
            SlideInWidget(
              delay: 800,
              child: DetailsText(
                text: 'Pending Amount : ₹ ${adminOverview.pendingAmount}',
              ),
            ),
            SlideInWidget(
              delay: 1000,
              child: DetailsText(
                text: 'Extra Amount : ₹ ${(adminOverview.extraAmount)}',
              ),
            ),
          ],
        ),
      ],
    );
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
                delay: 1200,
                child: Text(
                  'Payment details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SlideInWidget(
              delay: 1400,
              child: DetailsText(
                text: 'Total Not verified amount : ₹ ${provider.getTotalAmount(PaymentStatus.notVerified)}',
              ),
            ),
            SlideInWidget(
              delay: 1600,
              child: DetailsText(
                text: 'Total Accepted amount : ₹ ${provider.getTotalAmount(PaymentStatus.accepted)}',
              ),
            ),
            SlideInWidget(
              delay: 1800,
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
