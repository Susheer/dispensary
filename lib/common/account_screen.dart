import 'package:dispensary/models/account_model.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final Account account;

  AccountScreen({required this.account});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display Total Since Joining
          buildDetailRow(
            context: context,
            label: 'Total Since Joining',
            value: account.totalSinceJoining.toStringAsFixed(2),
          ),

          // Display Total Paid
          buildDetailRow(
            context: context,
            label: 'Total Paid',
            value: account.totalPaid.toStringAsFixed(2),
          ),

          // Display Pending Balance
          buildDetailRow(
            context: context,
            label: 'Pending Balance',
            value: account.pendingBalance.toStringAsFixed(2),
          ),
        ],
      ),
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
