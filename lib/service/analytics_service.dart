import 'package:baitulmaal/model/total_analytics_model.dart';
import 'package:baitulmaal/model/user_payment.dart';
import 'package:baitulmaal/utils/enums.dart';

import '../model/payment_model.dart';
import '../model/user_model.dart';

class AnalyticsService {
  static TotalAnalyticsModel getAdminOverview(List<UserModel> users) {
    int yearlyAmount = 0;
    int totalAmount = 0;
    int totalReceivedAmount = 0;
    int pendingAmount = 0;
    int extraAmount = 0;

    for (var user in users) {
      TotalAnalyticsModel analytics = user.analytics!;

      yearlyAmount = yearlyAmount + analytics.yearlyAmount;
      totalAmount = totalAmount + analytics.totalAmount;
      totalReceivedAmount = totalReceivedAmount + analytics.totalReceivedAmount;
      pendingAmount = pendingAmount + analytics.pendingAmount;
      extraAmount = extraAmount + analytics.extraAmount;
    }

    TotalAnalyticsModel adminAnalytics = TotalAnalyticsModel(
      yearlyAmount: yearlyAmount,
      totalAmount: totalAmount,
      totalReceivedAmount: totalReceivedAmount,
      pendingAmount: pendingAmount,
      extraAmount: extraAmount,
    );
    return adminAnalytics;
  }

  static List<UserPaymentModel> getUserPaymentList(List<UserModel> users, PaymentStatus status) {
    List<UserPaymentModel> payments = [];
    for (var user in users) {
      for (var payment in user.payments!) {
        // if need all payments or specific payments
        if (status == PaymentStatus.allPayments || payment.verify == status.index) {
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

  static TotalAnalyticsModel getUserAnalytics(int monthlyPayment, List<PaymentModel> payments) {
    int month = DateTime.now().month;
    int yearlyAmount = monthlyPayment * 12;
    int totalAmount = monthlyPayment * month;
    int receivedAmount = getTotalReceivedAmount(payments);
    int pendingAmount = totalAmount - receivedAmount;
    int extraAmount = 0;
    if (pendingAmount.isNegative) {
      extraAmount = pendingAmount;
      pendingAmount = 0;
    }

    TotalAnalyticsModel analytics = TotalAnalyticsModel(
      yearlyAmount: yearlyAmount,
      totalAmount: totalAmount,
      totalReceivedAmount: receivedAmount,
      pendingAmount: pendingAmount,
      extraAmount: extraAmount,
    );
    return analytics;
  }

  static int getTotalReceivedAmount(List<PaymentModel> payments) {
    int amount = 0;
    for (var pay in payments) {
      if (pay.verify == PaymentStatus.accepted.index) {
        amount = amount + pay.amount;
      }
    }
    return amount;
  }
}
