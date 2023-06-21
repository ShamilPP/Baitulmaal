import 'package:baitulmaal/model/user.dart';
import 'package:baitulmaal/utils/colors.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../animations/slide_animation.dart';
import '../../widgets/screen/user/profile/logout_button.dart';
import '../../widgets/screen/user/profile/password_list_tile.dart';
import '../../widgets/screen/user/profile/payment_list_tile.dart';
import '../../widgets/screen/user/profile/profile_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
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
                child: const Row(
                  children: [
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
                text: '₹ ${user.monthlyPayment[Provider.of<PaymentProvider>(context, listen: false).meekath]}',
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
