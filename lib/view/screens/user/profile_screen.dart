import 'package:flutter/material.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/utils/colors.dart';
import 'package:meekath/view/screens/user/transactions_screen.dart';

import '../../widgets/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  final bool isAdmin;

  const ProfileScreen({Key? key, required this.user, this.isAdmin = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //user profile photo
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                  child: Column(
                children: const [
                  Icon(
                    Icons.account_circle,
                    size: 130,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Change profile photo',
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              )),
            ),

            // User details
            ProfileListTile(text: user.name, subText: 'Name'),
            ProfileListTile(
                text: '${user.phoneNumber}', subText: 'Phone number'),
            ProfileListTile(text: user.username, subText: 'Username'),
            const ProfileListTile(text: '********', subText: 'Password'),
            ProfileListTile(
              text: '₹ ${user.monthlyPayment}',
              subText: 'Monthly payment',
            ),

            // Payment tile
            PaymentListTile(
              user: user,
            ),

            // Logout button
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Center(
                  child: isAdmin ? const SizedBox() : const LogoutButton()),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final String text;
  final String subText;

  const ProfileListTile({
    Key? key,
    required this.text,
    required this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subText,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
      ],
    );
  }
}

class PaymentListTile extends StatelessWidget {
  final UserModel user;

  const PaymentListTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payments',
              style: TextStyle(fontSize: 20),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey.shade700),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => UserTransactionScreen(user: user)));
      },
    );
  }
}
