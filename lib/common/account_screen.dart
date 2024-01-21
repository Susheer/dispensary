import 'package:dispensary/models/account_model.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final Account account;

  const AccountScreen({required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailRow(
          context: context,
          label: 'Total Since Joining',
          value: '₹${account.totalAmount.toStringAsFixed(2)}',
        ),

        // Display Total Paid
        buildDetailRow(
          context: context,
          label: 'Total Paid',
          value: '₹${account.totalPaidAmount.toStringAsFixed(2)}',
        ),

        // Display Pending Balance
        buildDetailRow(
          context: context,
          label: 'Pending Balance',
          value: '₹${account.totalPendingAmount.toStringAsFixed(2)}',
        ),
      ],
    );
  }

  Widget buildDetailRow({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
