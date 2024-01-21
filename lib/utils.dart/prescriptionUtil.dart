class PrescriptionUtil {
  static String calPendingBal(double total, double paid) {
    double pendingBalance = (total - paid);

    if (pendingBalance == 0.0) {
      return '₹0.00';
    } else if (pendingBalance > 0) {
      return '₹${pendingBalance.toStringAsFixed(2)}';
    } else {
      return '₹0.00';
    }
  }
}
