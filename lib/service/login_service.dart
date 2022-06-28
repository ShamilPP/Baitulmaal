import 'package:baitulmaal/model/response.dart';
import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/service/firebase_service.dart';

class LoginService {
  static Future<Response> loginAccount(String username, String password) async {
    UserModel? user = await FirebaseService.getUserWithUsername(username);
    if (username == 'admin' && password == await FirebaseService.getAdminPassword()) {
      // is admin returning admin
      return Response(value: 'admin', isSuccessful: true, message: 'Logged in');
    } else if (!checkInvalid(username)) {
      return Response(isSuccessful: false, message: 'Invalid username');
    } else if (!checkInvalid(password)) {
      return Response(isSuccessful: false, message: 'Invalid password');
    } else if (user == null) {
      return Response(isSuccessful: false, message: 'Username not exits');
    } else if (password != user.password) {
      return Response(isSuccessful: false, message: 'Password is incorrect');
    }
    // returning success and docId
    return Response(value: user.docId, isSuccessful: true, message: 'Logged in');
  }

  static Future<Response> createAccount(String name, String phoneNumber, String username, String password,
      String confirmPassword, String monthlyPayment) async {
    if (!checkInvalid(name)) {
      return Response(isSuccessful: false, message: 'Invalid name');
    } else if (!checkInvalid(phoneNumber)) {
      return Response(isSuccessful: false, message: 'Invalid phone number');
    } else if (!checkInvalid(username)) {
      return Response(isSuccessful: false, message: 'Invalid username');
    } else if (!checkInvalid(password)) {
      return Response(isSuccessful: false, message: 'Invalid password');
    } else if (!checkInvalid(monthlyPayment)) {
      return Response(isSuccessful: false, message: 'Invalid monthly payment');
    } else if (password != confirmPassword) {
      return Response(isSuccessful: false, message: 'Confirm password incorrect');
    } else if (!verifyPhoneNumber(phoneNumber)) {
      return Response(isSuccessful: false, message: 'Entered mobile number is invalid');
    } else if (int.tryParse(monthlyPayment) == null) {
      return Response(isSuccessful: false, message: 'Monthly payment invalid');
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
