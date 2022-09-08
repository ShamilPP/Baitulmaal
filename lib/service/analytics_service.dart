import 'package:baitulmaal/model/analytics_model.dart';
import 'package:baitulmaal/utils/enums.dart';

import '../model/payment_model.dart';
import '../model/user_model.dart';

class AnalyticsService {
  static AnalyticsModel getAdminOverview(List<UserModel> users, List<PaymentModel> payments) {
    int yearlyAmount = 0;
    int totalAmount = 0;
    int totalReceivedAmount = 0;
    int pendingAmount = 0;
    int extraAmount = 0;

    for (var user in users) {
      AnalyticsModel analytics = user.analytics!;

      yearlyAmount = yearlyAmount + analytics.yearlyAmount;
      totalAmount = totalAmount + analytics.totalAmount;
      totalReceivedAmount = totalReceivedAmount + analytics.totalReceivedAmount;
      pendingAmount = pendingAmount + analytics.pendingAmount;
      extraAmount = extraAmount + analytics.extraAmount;
    }

    AnalyticsModel adminAnalytics = AnalyticsModel(
      yearlyAmount: yearlyAmount,
      totalAmount: totalAmount,
      totalReceivedAmount: totalReceivedAmount,
      pendingAmount: pendingAmount,
      extraAmount: extraAmount,
    );
    return adminAnalytics;
  }

  static List<PaymentModel> getPaymentListWithStatus(List<PaymentModel> payments, PaymentStatus status) {
    List<PaymentModel> paymentList = [];
    for (var payment in payments) {
      // if need all payments or specific payments
      if (status.index == payment.verify || status == PaymentStatus.allPayments) {
        paymentList.add(payment);
      }
    }
    return paymentList;
  }

  static AnalyticsModel getUserAnalytics(List<PaymentModel> payments, UserModel user) {
    int month = DateTime.now().month;
    int yearlyAmount = user.monthlyPayment[DateTime.now().year]! * 12;
    int totalAmount = user.monthlyPayment[DateTime.now().year]! * month;
    int receivedAmount = getTotalAmountWithStatus(payments, PaymentStatus.accepted);
    int pendingAmount = totalAmount - receivedAmount;
    int extraAmount = 0;
    if (pendingAmount.isNegative) {
      extraAmount = pendingAmount.abs();
      pendingAmount = 0;
    }

    AnalyticsModel analytics = AnalyticsModel(
      yearlyAmount: yearlyAmount,
      totalAmount: totalAmount,
      totalReceivedAmount: receivedAmount,
      pendingAmount: pendingAmount,
      extraAmount: extraAmount,
    );
    return analytics;
  }

  static int getTotalAmountWithStatus(List<PaymentModel> payments, PaymentStatus status) {
    int amount = 0;
    for (var payment in payments) {
      if (status.index == payment.verify || status == PaymentStatus.allPayments) {
        amount = amount + payment.amount;
      }
    }
    return amount;
  }
}
