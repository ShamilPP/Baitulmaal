import 'package:baitulmaal/model/total_analytics_model.dart';
import 'package:baitulmaal/utils/enums.dart';

import '../model/payment_model.dart';
import '../model/user_model.dart';

class AnalyticsService {
  static TotalAnalyticsModel getAdminOverview(List<UserModel> users, List<PaymentModel> payments) {
    int yearlyAmount = 0;
    int totalAmount = 0;
    int totalReceivedAmount = 0;
    int pendingAmount = 0;
    int extraAmount = 0;

    for (var user in users) {
      TotalAnalyticsModel analytics = getUserAnalytics(payments, user);

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

  static TotalAnalyticsModel getUserAnalytics(List<PaymentModel> payments, UserModel user) {
    // get user payments from all payments
    List<PaymentModel> userPayments = [];
    for (var payment in payments) {
      if (payment.userDocId == user.docId) {
        userPayments.add(payment);
      }
    }

    int month = DateTime.now().month;
    int yearlyAmount = user.monthlyPayment * 12;
    int totalAmount = user.monthlyPayment * month;
    int receivedAmount = getTotalAmountWithStatus(userPayments, PaymentStatus.accepted);
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
