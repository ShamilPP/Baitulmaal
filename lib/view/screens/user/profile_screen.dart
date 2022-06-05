import 'package:flutter/material.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/utils/colors.dart';
import 'package:meekath/view/screens/user/payment_details_screen.dart';

import '../../../repo/login_service.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Profile"),
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
                    "Change profile photo",
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              )),
            ),

            // User details
            ProfileListTile(text: user.name, subText: "Name", needEdit: true),
            ProfileListTile(
                text: "${user.phoneNumber}",
                subText: "Phone number",
                needEdit: true),
            ProfileListTile(text: user.username, subText: "Username"),
            const ProfileListTile(
                text: "********", subText: "Password", needEdit: true),
            ProfileListTile(
                text: "₹ ${user.monthlyPayment}",
                subText: "Monthly payment",
                needEdit: true),

            // Payment tile
            PaymentListTile(
              user: user,
            ),

            // Logout button
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Center(child: LogoutButton()),
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
  final bool needEdit;

  const ProfileListTile({
    Key? key,
    required this.text,
    required this.subText,
    this.needEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
              needEdit
                  ? Icon(Icons.edit, size: 30, color: Colors.grey.shade800)
                  : const SizedBox(),
            ],
          ),
        ),
        const Divider(thickness: 1),
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Payments",
                  style: TextStyle(fontSize: 20),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 20, color: Colors.grey.shade800),
              ],
            ),
          ),
          const Divider(thickness: 1),
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PaymentDetailsScreen(
                      user: user,
                    )));
      },
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 45,
      child: TextButton(
        child: Text(
          "Logout",
          style: TextStyle(fontSize: 20, color: primaryColor),
        ),
        onPressed: () {
          LoginService.logout(context);
        },
      ),
    );
  }
}
