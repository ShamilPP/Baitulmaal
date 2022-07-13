import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/utils/colors.dart';
import 'package:baitulmaal/view/animations/slide_in_widget.dart';
import 'package:baitulmaal/view/screens/sign_up_screen.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/users_list.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserModel> users = [];
  final ValueNotifier<List<UserModel>> searchedUsers = ValueNotifier([]);

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    users = Provider.of<AdminProvider>(context, listen: false).users;
    searchedUsers.value = users;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                color: primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SlideInWidget(
                      delay: 400,
                      child: Text(
                        'Users',
                        style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 27, right: 27, top: 30),
                      child: SlideInWidget(
                        delay: 200,
                        child: TextField(
                          textAlign: TextAlign.start,
                          onChanged: onTextChanged,
                          controller: controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: InkWell(
                              child: const Icon(Icons.cancel),
                              onTap: () {
                                controller.clear();
                              },
                            ),
                          ),
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
          Positioned(
            right: 20,
            bottom: 20,
            child: SlideInWidget(
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignUpScreen(isAddUser: true),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTextChanged(String searchedName) {
    List<UserModel> _users = [];
    for (var user in users) {
      if (user.name.toLowerCase().contains(searchedName.toLowerCase()) ||
          user.username.toLowerCase().contains(searchedName.toLowerCase()) ||
          user.phoneNumber.toString().contains(searchedName)) {
        // Add user to list
        _users.add(user);
      }
    }
    searchedUsers.value = _users;
  }
}
