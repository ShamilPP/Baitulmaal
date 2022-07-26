import 'package:baitulmaal/view/screens/user/profile_screen.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/user_model.dart';
import 'list_card.dart';

class UsersList extends StatelessWidget {
  final List<UserModel> users;

  const UsersList({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AdminProvider>(context, listen: false);
    return Expanded(
      child: ListView.builder(
        cacheExtent: 0,
        itemCount: users.length,
        itemBuilder: (ctx, index) {
          UserModel user = users[index];
          var analytics = provider.getUserAnalytics(user);
          return ListCard(
            name: user.name,
            subText: analytics.pendingAmount != 0 ? 'PENDING ( ₹ ${analytics.pendingAmount} )' : 'COMPLETED',
            subColor: analytics.pendingAmount != 0 ? Colors.red : Colors.green,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: user, isAdmin: true)));
            },
          );
        },
      ),
    );
  }
}
