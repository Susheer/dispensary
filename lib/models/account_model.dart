class Account {
  late double _totalAmount;
  late double _totalPaidAmount;
  late double _totalPendingAmount;

  Account({
    required double totalAmount,
    required double totalPaidAmount,
    required double totalPendingAmount,
  })  : _totalAmount = totalAmount,
        _totalPaidAmount = totalPaidAmount,
        _totalPendingAmount = totalPendingAmount;

  // Getter for totalAmount
  double get totalAmount => _totalAmount;

  // Setter for totalAmount
  set totalAmount(double value) {
    _totalAmount = value;
  }

  // Getter for totalPaidAmount
  double get totalPaidAmount => _totalPaidAmount;

  // Setter for totalPaidAmount
  set totalPaidAmount(double value) {
    _totalPaidAmount = value;
  }

  // Getter for totalPendingAmount
  double get totalPendingAmount => _totalPendingAmount;

  // Setter for totalPendingAmount
  set totalPendingAmount(double value) {
    _totalPendingAmount = value;
  }

  // Convert Account object to a Map
  Map<String, dynamic> toMap() {
    return {
      'totalAmount': _totalAmount,
      'totalPaidAmount': _totalPaidAmount,
      'totalPendingAmount': _totalPendingAmount,
    };
  }

  // Create an Account object from a Map
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      totalAmount: map['total_amount'],
      totalPaidAmount: map['total_paid_amount'],
      totalPendingAmount: map['total_pending_amount'],
    );
  }
}
