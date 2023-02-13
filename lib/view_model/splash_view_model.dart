import 'package:baitulmaal/model/response.dart';
import 'package:baitulmaal/service/local_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../service/firebase_service.dart';

class SplashProvider extends ChangeNotifier {
  Future<int> getUpdateCode() async {
    Response response = await FirebaseService.getUpdateCode();
    if (response.isSuccess) {
      return response.value;
    } else {
      Fluttertoast.showToast(
        msg: response.value,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0,
        textColor: Colors.white,
        webPosition: "center",
        backgroundColor: Colors.red,
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
      );
      return 0; // 0 is error code
    }
  }

  Future<String?> getDocId() async {
    String? docId = await LocalService.getUser();
    return docId;
  }
}
