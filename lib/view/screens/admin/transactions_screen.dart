import 'package:flutter/material.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/view/screens/transactions_screen.dart';
import 'package:meekath/view_model/admin_view_model.dart';
import 'package:provider/provider.dart';

class AdminTransactionScreen extends StatelessWidget {
  const AdminTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = Provider.of<AdminProvider>(context).users;
    return TransactionScreen(users: users);
  }
}
