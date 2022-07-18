import 'package:baitulmaal/utils/colors.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/payment_model.dart';
import '../../utils/enums.dart';
import '../animations/slide_in_widget.dart';
import '../widgets/payment_list.dart';

class TransactionScreen extends StatelessWidget {
  final List<PaymentModel> payments;
  final bool isAdmin;

  const TransactionScreen({Key? key, required this.payments, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
            child: AppBar(
              backgroundColor: primaryColor,
              title: const SlideInWidget(
                delay: 1000,
                child: Text(
                  'Transactions',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400, color: Colors.white),
                ),
              ),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  SlideInWidget(delay: 200, child: Tab(text: 'All')),
                  SlideInWidget(delay: 400, child: Tab(text: 'Accepted')),
                  SlideInWidget(delay: 600, child: Tab(text: 'Rejected')),
                  SlideInWidget(delay: 800, child: Tab(text: 'Not verified')),
                ],
              ),
            ),
          ),
          Consumer<PaymentProvider>(builder: (ctx, provider, child) {
            List<PaymentModel> acceptedList = provider.getPaymentListWithStatus(payments, PaymentStatus.accepted);
            List<PaymentModel> rejectedList = provider.getPaymentListWithStatus(payments, PaymentStatus.rejected);
            List<PaymentModel> notVerifiedList = provider.getPaymentListWithStatus(payments, PaymentStatus.notVerified);
            return Expanded(
              child: TabBarView(
                children: [
                  // All payments tab
                  PaymentList(
                    paymentList: payments,
                    isAdmin: isAdmin,
                  ),

                  // Accepted tab
                  PaymentList(
                    paymentList: acceptedList,
                    isAdmin: isAdmin,
                  ),

                  // Rejected tab
                  PaymentList(
                    paymentList: rejectedList,
                    isAdmin: isAdmin,
                  ),

                  // Not verified tab
                  PaymentList(
                    paymentList: notVerifiedList,
                    isAdmin: isAdmin,
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
