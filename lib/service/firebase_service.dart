import 'package:baitulmaal/model/payment.dart';
import 'package:baitulmaal/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/response.dart';

class FirebaseService {
  static Future<Response> uploadUser(User user) async {
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

  static Future<bool> uploadPayment(Payment payment) async {
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

  static Future<List<User>> getAllUsers() async {
    List<User> users = [];

    var collection = FirebaseFirestore.instance.collection('users');
    var allDocs = await collection.get();
    for (var user in allDocs.docs) {
      users.add(User(
        docId: user.id,
        name: user.get('name'),
        phoneNumber: user.get('phoneNumber'),
        username: user.get('username'),
        password: user.get('password'),
        monthlyPayment: Map.from(user.get('monthlyPayment').map((key, value) => MapEntry(int.parse(key), value))),
      ));
    }
    return users;
  }

  static Future<User?> getUserWithUsername(String username) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var users = await collection.get();

    for (var user in users.docs) {
      if (user.get('username') == username) {
        // returning user data
        return User(
          docId: user.id,
          name: user.get('name'),
          phoneNumber: user.get('phoneNumber'),
          username: user.get('username'),
          password: user.get('password'),
          monthlyPayment: Map.from(user.get('monthlyPayment').map((key, value) => MapEntry(int.parse(key), value))),
        );
      }
    }
    return null;
  }

  static Future<User?> getUserWithPhoneNumber(int phone) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var users = await collection.get();

    for (var user in users.docs) {
      if (user.get('phoneNumber') == phone) {
        // returning user data
        return User(
          docId: user.id,
          name: user.get('name'),
          phoneNumber: user.get('phoneNumber'),
          username: user.get('username'),
          password: user.get('password'),
          monthlyPayment: Map.from(user.get('monthlyPayment').map((key, value) => MapEntry(int.parse(key), value))),
        );
      }
    }
    return null;
  }

  static Future<User?> getUserWithDocId(String docId) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var user = await collection.doc(docId).get();
    if (user.exists) {
      // returning user data
      return User(
        docId: user.id,
        name: user.get('name'),
        phoneNumber: user.get('phoneNumber'),
        username: user.get('username'),
        password: user.get('password'),
        monthlyPayment: Map.from(user.get('monthlyPayment').map((key, value) => MapEntry(int.parse(key), value))),
      );
    }
    return null;
  }

  static Future<List<Payment>> getAllPayments(int meekath, List<User> users) async {
    List<Payment> payments = [];
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
          Payment(
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

  static Future<Response> checkUserIsAlreadyExists(User user) async {
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

// it's temp code..don't effect application
// monthly meekath amount auto update from last year(2024) code
void autoUpdateMonthlyAmount() async {
  print('start');
  var users = (await FirebaseFirestore.instance.collection('users').get()).docs;
  for (var user in users) {
    var map = user.get('monthlyPayment');
    map['2024'] = map['2023']!;
    map['2025'] = map['2023']!;
    print(map);
    await FirebaseFirestore.instance.collection('users').doc(user.id).update({'monthlyPayment': map});
  }
  print('end');
}
