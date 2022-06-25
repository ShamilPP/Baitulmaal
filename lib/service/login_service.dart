import 'package:baitulmaal/model/login_response.dart';
import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/service/firebase_service.dart';

class LoginService {
  static Future<LoginResponse> loginAccount(
      String username, String password) async {
    UserModel? user = await FirebaseService.getUser(username, false);
    if (username == 'admin' &&
        password == await FirebaseService.getAdminPassword()) {
      // is admin returning admin
      return LoginResponse(
          isSuccessful: true, message: 'Logged in', username: 'admin');
    } else if (!checkInvalid(username)) {
      return LoginResponse(isSuccessful: false, message: 'Invalid username');
    } else if (!checkInvalid(password)) {
      return LoginResponse(isSuccessful: false, message: 'Invalid password');
    } else if (user == null) {
      return LoginResponse(isSuccessful: false, message: 'Username not exits');
    } else if (password != user.password) {
      return LoginResponse(
          isSuccessful: false, message: 'Password is incorrect');
    }
    // returning success and username
    return LoginResponse(
        isSuccessful: true, message: 'Logged in', username: username);
  }

  static Future<LoginResponse> createAccount(
      String name,
      String phoneNumber,
      String username,
      String password,
      String confirmPassword,
      String monthlyPayment) async {
    if (!checkInvalid(name)) {
      return LoginResponse(isSuccessful: false, message: 'Invalid name');
    } else if (!checkInvalid(phoneNumber)) {
      return LoginResponse(
          isSuccessful: false, message: 'Invalid phone number');
    } else if (!checkInvalid(username)) {
      return LoginResponse(isSuccessful: false, message: 'Invalid username');
    } else if (!checkInvalid(password)) {
      return LoginResponse(isSuccessful: false, message: 'Invalid password');
    } else if (!checkInvalid(monthlyPayment)) {
      return LoginResponse(
          isSuccessful: false, message: 'Invalid monthly payment');
    } else if (password != confirmPassword) {
      return LoginResponse(
          isSuccessful: false, message: 'Confirm password incorrect');
    } else if (!verifyPhoneNumber(phoneNumber)) {
      return LoginResponse(
          isSuccessful: false, message: 'Entered mobile number is invalid');
    } else if (int.tryParse(monthlyPayment) == null) {
      return LoginResponse(
          isSuccessful: false, message: 'Monthly payment invalid');
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
