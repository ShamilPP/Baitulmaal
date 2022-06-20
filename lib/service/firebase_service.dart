import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meekath/model/payment_model.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/service/analytics_service.dart';

import '../model/login_response.dart';
import '../model/user_analytics_model.dart';

class FirebaseService {
  static Future<LoginResponse> uploadUser(UserModel user) async {
    var users = FirebaseFirestore.instance.collection('users');
    // Check user is already exists
    LoginResponse alreadyExists = await checkUserIsAlreadyExists(user);
    if (!alreadyExists.isSuccessful) {
      return alreadyExists;
    }
    // Then uploading user to firebase
    await users.add({
      'name': user.name,
      'phoneNumber': user.phoneNumber,
      'username': user.username,
      'password': user.password,
      'monthlyPayment': user.monthlyPayment,
    });
    return LoginResponse(
        isSuccessful: true, message: 'Logged in', username: user.username);
  }

  static Future<bool> uploadPayment(PaymentModel payment) async {
    var payments = FirebaseFirestore.instance.collection('transactions');

    payments.add({
      'userId': payment.userDocId,
      'amount': payment.amount,
      // DateTime convert to timestamp
      'date': Timestamp.fromDate(payment.dateTime),
      'verify': payment.verify,
    });
    return false;
  }

  static Future updatePayment(String docId, int status) async {
    var collection = FirebaseFirestore.instance.collection('transactions');
    await collection.doc(docId).update({
      'verify': status,
    });
  }

  static Future<List<UserModel>> getAllUsers() async {
    List<UserModel> users = [];
    List<PaymentModel> allPayments = await getAllPayments();

    var collection = FirebaseFirestore.instance.collection('users');
    var allDocs = await collection.get();
    for (var user in allDocs.docs) {
      // Payments Details
      List<PaymentModel> payments = [];

      for (var payment in allPayments) {
        if (user.id == payment.userDocId) {
          payments.add(payment);
        }
      }

      UserAnalyticsModel analytics = AnalyticsService.getUserAnalytics(
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
    var collection = FirebaseFirestore.instance.collection('users');
    var users = await collection.get();

    for (var user in users.docs) {
      if (user.get('username') == username) {
        UserAnalyticsModel? analytics;
        List<PaymentModel> payments = [];

        // if need user payment details
        if (needAllDetails) {
          List<PaymentModel> allPayments = await getAllPayments();

          for (var payment in allPayments) {
            if (user.id == payment.userDocId) {
              payments.add(payment);
            }
          }
          analytics = AnalyticsService.getUserAnalytics(
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

  static Future<List<PaymentModel>> getAllPayments() async {
    List<PaymentModel> payments = [];
    var collection = FirebaseFirestore.instance.collection('transactions');

    var paymentCollection = await collection.get();

    for (var payment in paymentCollection.docs) {
      DateTime date = (payment.get('date') as Timestamp).toDate();
      // To take all the payments for this year
      if (date.year == DateTime.now().year) {
        payments.add(PaymentModel(
          docId: payment.id,
          userDocId: payment.get('userId'),
          amount: payment.get('amount'),
          verify: payment.get('verify'),
          // Timestamp convert to datetime
          dateTime: date,
        ));
      }
    }
    return payments;
  }

  static Future<LoginResponse> checkUserIsAlreadyExists(UserModel user) async {
    var users = await FirebaseFirestore.instance.collection('users').get();

    for (var _user in users.docs) {
      if (_user.get('username') == user.username) {
        return LoginResponse(
            isSuccessful: false, message: 'Username already exists');
      }
      if (_user.get('phoneNumber') == user.phoneNumber) {
        return LoginResponse(
            isSuccessful: false, message: 'Phone number already exists');
      }
    }
    return LoginResponse(isSuccessful: true, message: "Success");
  }

  static Future<String> getAdminPassword() async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('application')
        .doc('admin')
        .get();
    String password = documentSnapshot['password'];
    return password;
  }

  static Future<int> getMajorVersion() async {
    int version;
    var doc = await FirebaseFirestore.instance
        .collection('application')
        .doc('version')
        .get();

    // check document exists ( avoiding null exceptions )
    if (doc.exists && doc.data()!.containsKey("version")) {
      // if document exists, fetch version in firebase
      try {
        version = doc['version'];
      } catch (e) {
        version = 0;
      }
    } else {
      // if document not exists, manually assign 0 ( avoiding null exceptions )
      version = 0;
    }

    return version;
  }
}
