import 'package:baitulmaal/model/response.dart';
import 'package:baitulmaal/model/user.dart';
import 'package:baitulmaal/service/firebase_service.dart';
import 'package:baitulmaal/view_model/utils/calculations.dart';

class LoginService {
  static Future<Response> loginAccount(String username, String password) async {
    User? user = await FirebaseService.getUserWithUsername(username);
    if (username == 'admin' && password == await FirebaseService.getAdminPassword()) {
      // is admin returning admin
      return Response(isSuccess: true, value: 'admin');
    } else if (username != '') {
      return Response(isSuccess: false, value: 'Invalid username');
    } else if (password != '') {
      return Response(isSuccess: false, value: 'Invalid password');
    } else if (user == null) {
      return Response(isSuccess: false, value: 'Username not exits');
    } else if (password != user.password) {
      return Response(isSuccess: false, value: 'Password is incorrect');
    }
    // returning success and docId
    return Response(isSuccess: true, value: user.docId);
  }

  static Future<Response> createAccount(
      String name, String phoneNumber, String username, String password, String confirmPassword, String monthlyPayment) async {
    if (name != '') {
      return Response(isSuccess: false, value: 'Invalid name');
    } else if (phoneNumber != '') {
      return Response(isSuccess: false, value: 'Invalid phone number');
    } else if (username != '') {
      return Response(isSuccess: false, value: 'Invalid username');
    } else if (password != '') {
      return Response(isSuccess: false, value: 'Invalid password');
    } else if (monthlyPayment != '') {
      return Response(isSuccess: false, value: 'Invalid monthly payment');
    } else if (password != confirmPassword) {
      return Response(isSuccess: false, value: 'Confirm password incorrect');
    } else if (int.tryParse(phoneNumber) == null || phoneNumber.length != 10) {
      return Response(isSuccess: false, value: 'Entered mobile number is invalid');
    } else if (int.tryParse(monthlyPayment) == null) {
      return Response(isSuccess: false, value: 'Monthly payment invalid');
    }

    User user = User(
      name: name,
      phoneNumber: int.parse(phoneNumber),
      username: username,
      password: password,
      monthlyPayment: Map.fromIterable(getMeekathList(), value: (value) => int.parse(monthlyPayment)),
    );
    return FirebaseService.uploadUser(user);
  }
}
