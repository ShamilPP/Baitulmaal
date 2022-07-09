import 'package:baitulmaal/view/widgets/my_appbar.dart';
import 'package:baitulmaal/view_model/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/notification_list_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyAppBar(
      title: 'Notifications',
      child: Expanded(
        child: Consumer<NotificationProvider>(builder: (ctx, provider, child) {
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
        }),
      ),
    );
  }
}
