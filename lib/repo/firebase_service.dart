import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meekath/model/payment_model.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/repo/analytics_service.dart';
import 'package:meekath/repo/login_service.dart';

import '../model/user_analytics_model.dart';

class FirebaseService {
  static Future<bool> uploadUser(UserModel user) async {
    CollectionReference<Map<String, dynamic>> users =
        FirebaseFirestore.instance.collection('users');
    if (await checkUserIsAvailable(user)) {
      return false;
    }
    await users
        .add({
          'name': user.name,
          'phoneNumber': user.phoneNumber,
          'username': user.username,
          'password': user.password,
          'monthlyPayment': user.monthlyPayment,
        })
        .then((value) => LoginService.successToast('Logged in'))
        .catchError((error) => LoginService.errorToast('loginFailed : $error'));
    return true;
  }

  static Future<bool> uploadPayment(int amount, int verify, String userDocId) async {
    CollectionReference<Map<String, dynamic>> payments = FirebaseFirestore
        .instance
        .collection('users')
        .doc(userDocId)
        .collection('payments');

    payments.add({
      'amount': amount,
      'date': DateTime.now().toString(),
      'verify': verify,
    });
    return false;
  }

  static Future<List<UserModel>> getAllUsers() async {
    List<UserModel> users = [];

    CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot<Map<String, dynamic>> userCollection = await collection.get();
    for (var user in userCollection.docs) {
      List<PaymentModel> payments = [];
      var payDocs = await collection.doc(user.id).collection('payments').get();
      for (var paymentDoc in payDocs.docs) {
        payments.add(PaymentModel(
          docId: paymentDoc.id,
          amount: paymentDoc.get('amount'),
          verify: paymentDoc.get('verify'),
          dateTime: DateTime.parse(paymentDoc.get('date')),
        ));
      }

      UserAnalyticsModel analytics = await AnalyticsService.getUserAnalytics(
          user.get('monthlyPayment'), payments);

      users.add(UserModel(
        docId: user.id,
        name: user.get('name'),
        phoneNumber: user.get('phoneNumber'),
        username: user.get('username'),
        password: user.get('password'),
        monthlyPayment: user.get('monthlyPayment'),
        analytics: analytics,
        payments: payments,
      ));
    }
    return users;
  }

  static Future<UserModel?> getUser(
      String username, bool needAllDetails) async {
    CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot<Map<String, dynamic>> users = await collection.get();

    for (var user in users.docs) {
      if (user.get('username') == username) {
        UserAnalyticsModel? analytics;
        List<PaymentModel> payments = [];

        // if need user payment details
        if (needAllDetails) {
          var payDocs =
              await collection.doc(user.id).collection('payments').get();
          for (var paymentDoc in payDocs.docs) {
            payments.add(PaymentModel(
              docId: paymentDoc.id,
              amount: paymentDoc.get('amount'),
              dateTime: DateTime.parse(paymentDoc.get('date')),
              verify: paymentDoc.get('verify'),
            ));
          }

          analytics = await AnalyticsService.getUserAnalytics(
              user.get('monthlyPayment'), payments);
        }

        // returning user data
        return UserModel(
          docId: user.id,
          name: user.get('name'),
          phoneNumber: user.get('phoneNumber'),
          username: user.get('username'),
          password: user.get('password'),
          monthlyPayment: user.get('monthlyPayment'),
          analytics: analytics,
          payments: payments,
        );
      }
    }
    return null;
  }

  static Future<bool> checkUserIsAvailable(UserModel user) async {
    QuerySnapshot<Map<String, dynamic>> users =
        await FirebaseFirestore.instance.collection('users').get();

    for (var _user in users.docs) {
      if (_user.get('username') == user.username) {
        LoginService.errorToast('Username already exits');
        return true;
      }
      if (_user.get('phoneNumber') == user.phoneNumber) {
        LoginService.errorToast('Phone number already exits');
        return true;
      }
    }
    return false;
  }

  static Future<String> getAdminPassword() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('application')
            .doc('admin')
            .get();
    String password = documentSnapshot['password'];
    return password;
  }

  static Future<int> getLatestVersion() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('application')
            .doc('version')
            .get();
    int version = documentSnapshot['version'];
    return version;
  }
}
