import 'package:baitulmaal/view/screens/user/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../../model/user_model.dart';
import 'my_list_tile.dart';

class UsersList extends StatelessWidget {
  final List<UserModel> users;

  const UsersList({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (ctx, index) {
          UserModel user = users[index];

          return MyListTile(
            name: user.name,
            subText: user.analytics!.isPending
                ? 'PENDING ( ₹ ${user.analytics!.pendingAmount} )'
                : 'COMPLETED',
            subColor: user.analytics!.isPending ? Colors.red : Colors.green,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          ProfileScreen(user: user, isAdmin: true)));
            },
          );
        },
      ),
    );
  }
}
