import 'package:baitulmaal/view/screens/transactions_screen.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTransactionScreen extends StatelessWidget {
  const AdminTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(builder: (ctx, provider, child) {
      return TransactionScreen(payments: provider.payments, isAdmin: true);
    });
  }
}
