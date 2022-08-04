import 'package:baitulmaal/model/response.dart';
import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/service/firebase_service.dart';

class LoginService {
  static Future<Response> loginAccount(String username, String password) async {
    UserModel? user = await FirebaseService.getUserWithUsername(username);
    if (username == 'admin' && password == await FirebaseService.getAdminPassword()) {
      // is admin returning admin
      return Response(isSuccess: true, value: 'admin');
    } else if (!checkInvalid(username)) {
      return Response(isSuccess: false, value: 'Invalid username');
    } else if (!checkInvalid(password)) {
      return Response(isSuccess: false, value: 'Invalid password');
    } else if (user == null) {
      return Response(isSuccess: false, value: 'Username not exits');
    } else if (password != user.password) {
      return Response(isSuccess: false, value: 'Password is incorrect');
    }
    // returning success and docId
    return Response(isSuccess: true, value: user.docId);
  }

  static Future<Response> createAccount(String name, String phoneNumber, String username, String password,
      String confirmPassword, String monthlyPayment) async {
    if (!checkInvalid(name)) {
      return Response(isSuccess: false, value: 'Invalid name');
    } else if (!checkInvalid(phoneNumber)) {
      return Response(isSuccess: false, value: 'Invalid phone number');
    } else if (!checkInvalid(username)) {
      return Response(isSuccess: false, value: 'Invalid username');
    } else if (!checkInvalid(password)) {
      return Response(isSuccess: false, value: 'Invalid password');
    } else if (!checkInvalid(monthlyPayment)) {
      return Response(isSuccess: false, value: 'Invalid monthly payment');
    } else if (password != confirmPassword) {
      return Response(isSuccess: false, value: 'Confirm password incorrect');
    } else if (!verifyPhoneNumber(phoneNumber)) {
      return Response(isSuccess: false, value: 'Entered mobile number is invalid');
    } else if (int.tryParse(monthlyPayment) == null) {
      return Response(isSuccess: false, value: 'Monthly payment invalid');
    }
    UserModel user = UserModel(
      name: name,
      phoneNumber: int.parse(phoneNumber),
      username: username,
      password: password,
      monthlyPayment: int.parse(monthlyPayment),
    );
    return FirebaseService.uploadUser(user);
  }

  static bool verifyPhoneNumber(String number) {
    int? phoneNumber = int.tryParse(number);
    if (phoneNumber != null && number.length == 10) {
      return true;
    }
    return false;
  }

  static bool checkInvalid(String text) {
    if (text == '') {
      return false;
    }
    return true;
  }
}
