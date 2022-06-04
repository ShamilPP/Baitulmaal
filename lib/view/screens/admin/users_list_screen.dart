import 'package:flutter/material.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/utils/colors.dart';
import 'package:meekath/view_model/admin_view_model.dart';
import 'package:provider/provider.dart';

import '../../widgets/users_list.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({Key? key}) : super(key: key);

  List<UserModel> users = [];
  final ValueNotifier<List<UserModel>> searchedUsers = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    users = Provider.of<AdminProvider>(context).users;
    searchedUsers.value = users;
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Users",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 27, right: 27, top: 30),
                  child: TextField(
                    textAlign: TextAlign.start,
                    onChanged: onTextChanged,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.cancel),
                    ),
                  ),
                )
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: searchedUsers,
            builder: (context, List<UserModel> users, _) {
              return UsersList(users: users);
            },
          ),
        ],
      ),
    );
  }

  void onTextChanged(String searchedName) {
    List<UserModel> _users = [];
    for (var user in users) {
      if (user.name.toLowerCase().contains(searchedName.toLowerCase())) {
        _users.add(user);
      }
    }
    searchedUsers.value = _users;
  }
}
