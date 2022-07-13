import 'package:baitulmaal/view_model/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/notification_list_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // run loadlist after build method complete
    WidgetsBinding.instance?.addPostFrameCallback((_) => loadList(context));
  }

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
                  initialItemCount: 0,
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

  loadList(BuildContext context) async {
    var provider = Provider.of<NotificationProvider>(context, listen: false);
    var key = provider.listKey;
    for (int i = 0; i < provider.paymentNotVerifiedList.length; i++) {
      if (key.currentState == null) break;
      key.currentState!.insertItem(i);
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}
