import 'package:flutter/material.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/model/user_payment.dart';
import 'package:meekath/repo/analytics_service.dart';
import 'package:meekath/utils/constants.dart';
import 'package:meekath/view/widgets/logout_button.dart';
import 'package:provider/provider.dart';

import '../../../model/admin_overview_model.dart';
import '../../../view_model/admin_view_model.dart';
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
                    child: Text(
                      "Analytics",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
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
                            AdminProvider provider = Provider.of<AdminProvider>(
                                context,
                                listen: false);
                            provider.showMyDialog(context, "Updating...");
                            await Provider.of<AdminProvider>(context,
                                    listen: false)
                                .initData();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Consumer<AdminProvider>(
                builder: (ctx, provider, child) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 17, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnalyticsSection(adminOverview: provider.adminOverview),
                        PaymentSection(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          // Logout button
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: LogoutButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsSection extends StatelessWidget {
  final AdminOverviewModel adminOverview;

  const AnalyticsSection({Key? key, required this.adminOverview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AmountPercentageIndicator(
          percentage:
              1 - (adminOverview.pendingAmount / adminOverview.totalAmount),
          centerIconColor: Colors.black,
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsText(
              text: "Total Amount : ₹ ${adminOverview.totalAmount}",
            ),
            DetailsText(
              text:
                  "Total Received : ₹ ${adminOverview.totalAmount - adminOverview.pendingAmount}",
            ),
            DetailsText(
              text: "Pending Amount : ₹ ${adminOverview.pendingAmount}",
            ),
            DetailsText(
              text:
                  "Extra Amount : ₹ ${(adminOverview.totalAmount - adminOverview.totalReceivedAmount - adminOverview.pendingAmount).abs()}",
            ),
          ],
        ),
      ],
    );
  }
}

class PaymentSection extends StatelessWidget {
  PaymentSection({Key? key}) : super(key: key);

  List<UserModel> users = [];
  List<UserPaymentModel> _notVerifiedPayments = [];
  List<UserPaymentModel> _acceptedPayments = [];
  List<UserPaymentModel> _rejectedPayments = [];

  @override
  Widget build(BuildContext context) {
    users = Provider.of<AdminProvider>(context).users;
    _notVerifiedPayments =
        AnalyticsService.getUserPaymentList(users, paymentNotVerified);
    _acceptedPayments =
        AnalyticsService.getUserPaymentList(users, paymentAccepted);
    _rejectedPayments =
        AnalyticsService.getUserPaymentList(users, paymentRejected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40, bottom: 10),
          child: Text(
            "Payment details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        DetailsText(
          text:
              "Total Not verified amount : ₹ ${AnalyticsService.getTotalAmount(_notVerifiedPayments)}",
        ),
        DetailsText(
          text:
              "Total Accepted amount : ₹ ${AnalyticsService.getTotalAmount(_acceptedPayments)}",
        ),
        DetailsText(
          text:
              "Total Rejected amount : ₹ ${AnalyticsService.getTotalAmount(_rejectedPayments)}",
        ),
      ],
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
