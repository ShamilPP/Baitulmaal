import 'package:meekath/model/admin_overview_model.dart';
import 'package:meekath/model/user_analytics_model.dart';
import 'package:meekath/model/user_payment.dart';
import 'package:meekath/repo/firebase_service.dart';

import '../model/payment_model.dart';
import '../model/user_model.dart';
import '../utils/constants.dart';

class AnalyticsService {
  static Future<AdminOverviewModel> getAdminOverview(
      List<UserModel> users) async {
    int totalUsers = users.length;
    int pendingUsers = 0;
    int totalAmount = 0;
    int totalReceivedAmount = 0;
    int pendingAmount = 0;
    int meekathMonth = await FirebaseService.getFirebaseData(
        "application", "meekath", "month");
    int meekath = await FirebaseService.getFirebaseData(
        "application", "meekath", "meekath");

    for (var user in users) {
      UserAnalyticsModel analytics = user.analytics!;
      totalAmount = totalAmount + analytics.totalAmount;
      totalReceivedAmount = totalReceivedAmount + analytics.totalReceivedAmount;
      pendingAmount = pendingAmount + analytics.pendingAmount;

      if (analytics.isPending) {
        pendingUsers++;
      }
    }

    AdminOverviewModel adminOverview = AdminOverviewModel(
        totalUsers: totalUsers,
        pendingUsers: pendingUsers,
        totalAmount: totalAmount,
        totalReceivedAmount: totalReceivedAmount,
        pendingAmount: pendingAmount,
        meekathMonth: meekathMonth,
        meekath: meekath);
    return adminOverview;
  }

  static List<UserPaymentModel> getUserPaymentList(
      List<UserModel> users, int status) {
    List<UserPaymentModel> payments = [];
    for (var user in users) {
      for (var payment in user.payments) {
        // 123 == All Payment details
        if (status == allPayments || payment.verify == status) {
          payments.add(UserPaymentModel(
            user: user,
            payment: payment,
          ));
        }
      }
    }
    payments.sort((a, b) => b.payment.dateTime.compareTo(a.payment.dateTime));
    return payments;
  }

  static Future<UserAnalyticsModel> getUserAnalytics(
      int monthlyPayment, List<PaymentModel> payments) async {
    int meekathMonth = await FirebaseService.getFirebaseData(
        "application", "meekath", "month");
    int totalAmount = monthlyPayment * meekathMonth;
    int receivedAmount = getTotalReceivedAmount(payments);
    int pendingAmount = checkNegative(totalAmount - receivedAmount);

    UserAnalyticsModel analytics = UserAnalyticsModel(
      totalAmount: totalAmount,
      totalReceivedAmount: receivedAmount,
      pendingAmount: pendingAmount,
      isPending: pendingAmount == 0 ? false : true,
    );
    return analytics;
  }

  static int checkNegative(int amount) {
    if (amount.isNegative) {
      return 0;
    }
    return amount;
  }

  static int getTotalAmount(List<UserPaymentModel> payments) {
    int total = 0;
    for (var pay in payments) {
      total = total + pay.payment.amount;
    }
    return total;
  }

  static int getTotalReceivedAmount(List<PaymentModel> payments) {
    int amount = 0;
    for (var pay in payments) {
      if (pay.verify == paymentAccepted) {
        amount = amount + pay.amount;
      }
    }
    return amount;
  }
}
