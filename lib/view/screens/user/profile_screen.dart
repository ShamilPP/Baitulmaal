import 'package:flutter/material.dart';
import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/utils/colors.dart';
import 'package:baitulmaal/view/screens/user/transactions_screen.dart';

import '../../widgets/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  final bool isAdmin;

  const ProfileScreen({Key? key, required this.user, this.isAdmin = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// AppBar
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: const [
                    CloseButton(),
                    SizedBox(width: 15),
                    Text(
                      "Profile",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),

              /// User profile photo
              Center(
                child: Stack(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 130,
                      color: Colors.grey,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Colors.white,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// User details
              ProfileListTile(text: user.name, subText: 'Name'),
              ProfileListTile(
                  text: '+91 ${user.phoneNumber}', subText: 'Phone number'),
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
    return Container(
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(
            thickness: 1,
            height: 10,
            color: Colors.grey,
          )
        ],
      ),
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
