import 'package:baitulmaal/model/user.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../animations/slide_animation.dart';
import '../../widgets/general/users_list.dart';
import '../sign_up_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> users = [];
  final ValueNotifier<List<User>> searchedUsers = ValueNotifier([]);

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
    return Stack(
      children: [
        Column(
          children: [
            // AppBar
            appBar(),

            //Users list
            ValueListenableBuilder(
              valueListenable: searchedUsers,
              builder: (context, List<User> users, _) {
                return UsersList(users: users);
              },
            ),
          ],
        ),

        // Floating action button
        Positioned(
          right: 20,
          bottom: 20,
          child: SlideAnimation(
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
    );
  }

  Widget appBar() {
    return SizedBox(
      height: 170,
      child: AppBar(
        centerTitle: true,
        title: const SlideAnimation(
          delay: 400,
          child: Text(
            'Users',
            style: TextStyle(fontSize: 33, color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: SlideAnimation(
              delay: 200,
              child: TextField(
                textAlign: TextAlign.start,
                onChanged: onTextChanged,
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search users',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
          ),
        ),
      ),
    );
  }

  void onTextChanged(String searchedName) {
    List<User> _users = [];
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
