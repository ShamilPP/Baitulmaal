import 'package:meekath/model/success_failure_model.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/service/firebase_service.dart';

class LoginService {
  static Future<SuccessFailModel> loginAccount(
      String username, String password) async {
    UserModel? user = await FirebaseService.getUser(username, false);
    if (username == 'admin' &&
        password == await FirebaseService.getAdminPassword()) {
      // is admin returning admin
      return SuccessFailModel(
          isSucceed: true, message: 'Logged in', username: 'admin');
    } else if (!checkInvalid(username)) {
      return SuccessFailModel(isSucceed: false, message: 'Invalid username');
    } else if (!checkInvalid(password)) {
      return SuccessFailModel(isSucceed: false, message: 'Invalid password');
    } else if (user == null) {
      return SuccessFailModel(isSucceed: false, message: 'Username not exits');
    } else if (password != user.password) {
      return SuccessFailModel(
          isSucceed: false, message: 'Password is incorrect');
    }
    // returning success and username
    return SuccessFailModel(
        isSucceed: true, message: 'Logged in', username: username);
  }

  static Future<SuccessFailModel> createAccount(
      String name,
      String phoneNumber,
      String username,
      String password,
      String confirmPassword,
      String monthlyPayment) async {
    if (!checkInvalid(name)) {
      return SuccessFailModel(isSucceed: false, message: 'Invalid name');
    } else if (!checkInvalid(phoneNumber)) {
      return SuccessFailModel(
          isSucceed: false, message: 'Invalid phone number');
    } else if (!checkInvalid(username)) {
      return SuccessFailModel(isSucceed: false, message: 'Invalid username');
    } else if (!checkInvalid(password)) {
      return SuccessFailModel(isSucceed: false, message: 'Invalid password');
    } else if (!checkInvalid(monthlyPayment)) {
      return SuccessFailModel(
          isSucceed: false, message: 'Invalid monthly payment');
    } else if (password != confirmPassword) {
      return SuccessFailModel(
          isSucceed: false, message: 'Confirm password incorrect');
    } else if (!verifyPhoneNumber(phoneNumber)) {
      return SuccessFailModel(
          isSucceed: false, message: 'Entered mobile number is invalid');
    } else if (int.tryParse(monthlyPayment) == null) {
      return SuccessFailModel(
          isSucceed: false, message: 'Monthly payment invalid');
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
