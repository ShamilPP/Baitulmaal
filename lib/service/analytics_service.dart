import 'package:baitulmaal/model/analytics.dart';
import 'package:baitulmaal/utils/enums.dart';

import '../model/payment.dart';
import '../model/user.dart';

class AnalyticsService {
  static Analytics getAdminOverview(List<User> users, List<Payment> payments) {
    int yearlyAmount = 0;
    int totalAmount = 0;
    int totalReceivedAmount = 0;
    int pendingAmount = 0;
    int extraAmount = 0;

    for (var user in users) {
      Analytics analytics = user.analytics!;

      yearlyAmount = yearlyAmount + analytics.yearlyAmount;
      totalAmount = totalAmount + analytics.totalAmount;
      totalReceivedAmount = totalReceivedAmount + analytics.totalReceivedAmount;
      pendingAmount = pendingAmount + analytics.pendingAmount;
      extraAmount = extraAmount + analytics.extraAmount;
    }

    Analytics adminAnalytics = Analytics(
      yearlyAmount: yearlyAmount,
      totalAmount: totalAmount,
      totalReceivedAmount: totalReceivedAmount,
      pendingAmount: pendingAmount,
      extraAmount: extraAmount,
    );
    return adminAnalytics;
  }

  static List<Payment> getPaymentListWithStatus(List<Payment> payments, PaymentStatus status) {
    List<Payment> paymentList = [];
    for (var payment in payments) {
      // if need all payments or specific payments
      if (status.index == payment.verify || status == PaymentStatus.allPayments) {
        paymentList.add(payment);
      }
    }
    return paymentList;
  }

  static Analytics getUserAnalytics(List<Payment> payments, User user, int meekath) {
    // If not equal to this meekath, calculate a full year
    int month = meekath == DateTime.now().year ? DateTime.now().month : 12;
    int yearlyAmount = user.monthlyPayment[meekath]! * 12;
    int totalAmount = user.monthlyPayment[meekath]! * month;
    int receivedAmount = getTotalAmountWithStatus(payments, PaymentStatus.accepted);
    int pendingAmount = totalAmount - receivedAmount;
    int extraAmount = 0;
    if (pendingAmount.isNegative) {
      extraAmount = pendingAmount.abs();
      pendingAmount = 0;
    }

    Analytics analytics = Analytics(
      yearlyAmount: yearlyAmount,
      totalAmount: totalAmount,
      totalReceivedAmount: receivedAmount,
      pendingAmount: pendingAmount,
      extraAmount: extraAmount,
    );
    return analytics;
  }

  static int getTotalAmountWithStatus(List<Payment> payments, PaymentStatus status) {
    int amount = 0;
    for (var payment in payments) {
      if (status.index == payment.verify || status == PaymentStatus.allPayments) {
        amount = amount + payment.amount;
      }
    }
    return amount;
  }
}
