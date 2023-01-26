import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/user_model.dart';
import '../../../../screens/pay_screen.dart';

class PayForUserDialog extends StatelessWidget {
  final List<UserModel> users;

  PayForUserDialog({Key? key, required this.users}) : super(key: key);

  final ValueNotifier<List<UserModel>> searchedUsers = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    int meekath = Provider.of<PaymentProvider>(context, listen: false).meekath;
    searchedUsers.value = users;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.grey.shade200,
      child: SizedBox(
        width: 300,
        height: 400,
        child: Column(
          children: [
            // AppBar
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              child: Row(
                children: const [
                  CloseButton(),
                  SizedBox(width: 10),
                  Text(
                    'Pay the user',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),

            // Search TextField
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                textAlign: TextAlign.start,
                onChanged: onChanged,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // Users List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: searchedUsers,
                builder: (context, List<UserModel> users, _) {
                  return ListView.separated(
                    itemCount: searchedUsers.value.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        title: Text(searchedUsers.value[index].name),
                        subtitle: Text('₹ ${searchedUsers.value[index].monthlyPayment[meekath]}'),
                        onTap: () {
                          // Go to pay screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PayScreen(
                                user: searchedUsers.value[index],
                                isAdmin: true,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const Divider(thickness: 1, height: 0);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onChanged(String searchedName) {
    List<UserModel> _users = [];
    for (var user in users) {
      if (user.name.toLowerCase().contains(searchedName.toLowerCase())) {
        _users.add(user);
      }
    }
    searchedUsers.value = _users;
  }
}
