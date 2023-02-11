import 'package:baitulmaal/model/user.dart';
import 'package:baitulmaal/service/analytics_service.dart';
import 'package:baitulmaal/service/firebase_service.dart';
import 'package:flutter/material.dart';

import '../model/payment.dart';
import '../service/local_service.dart';

class UserProvider extends ChangeNotifier {
  late String _docId;
  late User _user;
  late List<Payment> _payments;

  String get docId => _docId;

  User get user => _user;

  List<Payment> get payments => _payments;

  Future<bool> loadDataFromFirebase(int meekath) async {
    // Get User wth docID ( DocId getting from shared preferences )
    await FirebaseService.getUserWithDocId(docId).then((User? result) {
      if (result == null) {
        // Remove DocId from shared preferences
        LocalService.removeUser();
      } else {
        _user = result;
      }
    });

    // Get user payments ( The function that gets all payments is called but only one user is passed as argument so only one user payment is received)
    _payments = await FirebaseService.getAllPayments(meekath, List.filled(1, _user));

    // Get user analytics
    user.analytics = AnalyticsService.getUserAnalytics(payments, user, meekath);
    notifyListeners();
    return true;
  }

  void setDocID(String docId) {
    _docId = docId;
  }
}
