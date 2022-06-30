import 'package:baitulmaal/utils/enums.dart';
import 'package:baitulmaal/view/widgets/my_appbar.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/admin_view_model.dart';
import '../../widgets/notification_list_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyAppBar(
      title: 'Notifications',
      child: Expanded(
        child: Consumer<AdminProvider>(builder: (ctx, provider, child) {
          var paymentProvider = Provider.of<PaymentProvider>(context);
          var paymentList = paymentProvider.getUserPaymentList(provider.users, PaymentStatus.notVerified);
          return ListView.builder(
            itemCount: paymentList.length,
            itemBuilder: (ctx, index) {
              return NotificationListTile(
                userPayment: paymentList[index],
              );
            },
          );
        }),
      ),
    );
  }
}
