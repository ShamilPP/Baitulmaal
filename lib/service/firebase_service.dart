import 'package:baitulmaal/model/payment_model.dart';
import 'package:baitulmaal/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/response.dart';

class FirebaseService {
  static Future<Response> uploadUser(UserModel user) async {
    var users = FirebaseFirestore.instance.collection('users');
    // Check user is already exists
    Response alreadyExists = await checkUserIsAlreadyExists(user);
    if (!alreadyExists.isSuccess) {
      return alreadyExists;
    }
    // Then uploading user to firebase
    var result = await users.add({
      'name': user.name,
      'phoneNumber': user.phoneNumber,
      'username': user.username,
      'password': user.password,
      'monthlyPayment': user.monthlyPayment.map((key, value) => MapEntry(key.toString(), value)),
    });
    return Response(isSuccess: true, value: result.id);
  }

  static Future<bool> uploadPayment(PaymentModel payment) async {
    var payments = FirebaseFirestore.instance.collection('transactions');

    payments.add({
      'userId': payment.userDocId,
      'amount': payment.amount,
      // DateTime convert to timestamp
      'date': Timestamp.fromDate(payment.dateTime),
      'meekath': payment.meekath,
      'verify': payment.verify,
    });
    return false;
  }

  static Future<bool> updatePayment(String docId, int status) async {
    var collection = FirebaseFirestore.instance.collection('transactions');
    await collection.doc(docId).update({
      'verify': status,
    });
    return true;
  }

  static Future<List<UserModel>> getAllUsers() async {
    List<UserModel> users = [];

    var collection = FirebaseFirestore.instance.collection('users');
    var allDocs = await collection.get();
    for (var user in allDocs.docs) {
      users.add(UserModel(
        docId: user.id,
        name: user.get('name'),
        phoneNumber: user.get('phoneNumber'),
        username: user.get('username'),
        password: user.get('password'),
        monthlyPayment:
            Map.from(user.get('monthlyPayment').map((key, value) => MapEntry(int.parse(key), value))),
      ));
    }
    return users;
  }

  static Future<UserModel?> getUserWithUsername(String username) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var users = await collection.get();

    for (var user in users.docs) {
      if (user.get('username') == username) {
        // returning user data
        return UserModel(
          docId: user.id,
          name: user.get('name'),
          phoneNumber: user.get('phoneNumber'),
          username: user.get('username'),
          password: user.get('password'),
          monthlyPayment:
              Map.from(user.get('monthlyPayment').map((key, value) => MapEntry(int.parse(key), value))),
        );
      }
    }
    return null;
  }

  static Future<UserModel?> getUserWithDocId(String docId) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var user = await collection.doc(docId).get();
    if (user.exists) {
      // returning user data
      return UserModel(
        docId: user.id,
        name: user.get('name'),
        phoneNumber: user.get('phoneNumber'),
        username: user.get('username'),
        password: user.get('password'),
        monthlyPayment:
            Map.from(user.get('monthlyPayment').map((key, value) => MapEntry(int.parse(key), value))),
      );
    }
    return null;
  }

  static Future<List<PaymentModel>> getAllPayments(int meekath, List<UserModel> users) async {
    List<PaymentModel> payments = [];
    var collection = FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('date', descending: true)
        .where('meekath', isEqualTo: meekath);

    var paymentCollection = await collection.get();

    for (var payment in paymentCollection.docs) {
      // find paid user
      int userIndex = users.indexWhere((user) => user.docId == payment.get('userId'));

      // returning payments
      if (userIndex != -1) {
        payments.add(
          PaymentModel(
            docId: payment.id,
            userDocId: payment.get('userId'),
            user: users[userIndex],
            amount: payment.get('amount'),
            verify: payment.get('verify'),
            meekath: payment.get('meekath'),
            // Timestamp convert to datetime
            dateTime: (payment.get('date') as Timestamp).toDate(),
          ),
        );
      }
    }
    return payments;
  }

  static Future<Response> checkUserIsAlreadyExists(UserModel user) async {
    var users = await FirebaseFirestore.instance.collection('users').get();

    for (var _user in users.docs) {
      if (_user.get('username') == user.username) {
        return Response(isSuccess: false, value: 'Username already exists');
      }
      if (_user.get('phoneNumber') == user.phoneNumber) {
        return Response(isSuccess: false, value: 'Phone number already exists');
      }
    }
    return Response(isSuccess: true, value: "Success");
  }

  static Future<String> getAdminPassword() async {
    var documentSnapshot = await FirebaseFirestore.instance.collection('application').doc('admin').get();
    String password = documentSnapshot['password'];
    return password;
  }

  static Future<Response> getUpdateCode() async {
    int code;
    DocumentSnapshot<Map<String, dynamic>> doc;
    try {
      doc = await FirebaseFirestore.instance.collection('application').doc('update').get();
    } catch (e) {
      return Response(isSuccess: false, value: 'Error detected : $e');
    }
    // check document exists ( avoiding null exceptions )
    if (doc.exists && doc.data()!.containsKey("code")) {
      // if document exists, fetch version in firebase
      try {
        code = doc['code'];
        return Response(isSuccess: true, value: code);
      } catch (e) {
        return Response(isSuccess: false, value: 'Error detected : $e');
      }
    } else {
      return Response(isSuccess: false, value: 'Error detected : Update code fetching problem');
    }
  }
}
