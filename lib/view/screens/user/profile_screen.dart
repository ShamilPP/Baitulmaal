import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/utils/colors.dart';
import 'package:baitulmaal/view/screens/user/transactions_screen.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/payment_model.dart';
import '../../../view_model/user_view_model.dart';
import '../../animations/slide_in_widget.dart';
import '../../widgets/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  final bool isAdmin;

  const ProfileScreen({Key? key, required this.user, this.isAdmin = false}) : super(key: key);

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
                    const SlideAnimation(
                      delay: 200,
                      child: Icon(
                        Icons.account_circle,
                        size: 130,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: SlideAnimation(
                        delay: 400,
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
                    ),
                  ],
                ),
              ),

              /// User details
              ProfileListTile(text: user.name, subText: 'Name'),
              ProfileListTile(text: '+91 ${user.phoneNumber}', subText: 'Phone number'),
              ProfileListTile(text: user.username, subText: 'Username'),
              PasswordListTile(password: user.password),
              ProfileListTile(
                text: '₹ ${user.monthlyPayment}',
                subText: 'Monthly payment',
              ),

              // Payment tile
              PaymentListTile(
                user: user,
                isAdmin: isAdmin,
              ),

              // Logout button
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Center(child: isAdmin ? const SizedBox() : const LogoutButton()),
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
          SlideAnimation(
            delay: 600,
            child: Text(
              subText,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 5),
          SlideAnimation(
            delay: 800,
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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

class PasswordListTile extends StatefulWidget {
  final String password;

  const PasswordListTile({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  State<PasswordListTile> createState() => _PasswordListTileState();
}

class _PasswordListTileState extends State<PasswordListTile> {
  bool isShowing = false;
  late String text = getHidePassword();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SlideAnimation(
                    delay: 600,
                    child: Text(
                      'Password',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SlideAnimation(
                    delay: 800,
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SlideAnimation(
                delay: 1000,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Icon(
                      isShowing ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isShowing = !isShowing;
                      if (isShowing) {
                        text = widget.password;
                      } else {
                        text = getHidePassword();
                      }
                    });
                  },
                ),
              )
            ],
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

  String getHidePassword() {
    String _pass = '';
    for (int i = 0; i < widget.password.length; i++) {
      _pass = _pass + '•';
    }
    return _pass;
  }
}

class PaymentListTile extends StatelessWidget {
  final UserModel user;
  final bool isAdmin;

  const PaymentListTile({Key? key, required this.user, required this.isAdmin}) : super(key: key);

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
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade700),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => UserTransactionScreen(payments: getPayments(context))));
      },
    );
  }

  List<PaymentModel> getPayments(BuildContext context) {
    late List<PaymentModel> payments;
    if (isAdmin) {
      var provider = Provider.of<AdminProvider>(context, listen: false);
      payments = provider.getUserPayments(user);
    } else {
      var provider = Provider.of<UserProvider>(context, listen: false);
      payments = provider.payments;
    }
    return payments;
  }
}
