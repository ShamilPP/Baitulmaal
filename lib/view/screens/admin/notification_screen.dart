import 'package:baitulmaal/view_model/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/notification_list_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Notifications',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<NotificationProvider>(
              builder: (ctx, provider, child) {
                return AnimatedList(
                  key: provider.listKey,
                  initialItemCount: provider.paymentNotVerifiedList.length,
                  itemBuilder: (ctx, index, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: NotificationListTile(
                        index: index,
                        userPayment: provider.paymentNotVerifiedList[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
