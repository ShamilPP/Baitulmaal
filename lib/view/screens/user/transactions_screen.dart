import 'package:baitulmaal/model/user_model.dart';
import 'package:flutter/material.dart';

import '../transactions_screen.dart';

class UserTransactionScreen extends StatelessWidget {
  final UserModel user;

  const UserTransactionScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TransactionScreen(
          users: List<UserModel>.filled(1, user),
        ),
      ),
    );
  }
}
