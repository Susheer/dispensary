import 'package:flutter/material.dart';

class FutureDatePicker extends StatelessWidget {
  late DateTime? defaultDate;
  String label;
  final Function(DateTime) onDateSelected;

  FutureDatePicker({
    Key? key,
    required this.onDateSelected,
    required this.label,
    this.defaultDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = defaultDate ?? DateTime.now();

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, 50)), // Adjust the height as needed
          ),
          onPressed: () {
            _selectDate(context).then((DateTime? selected) {
              if (selected != null) {
                selectedDate = selected;
                onDateSelected(selectedDate);
              }
            });
          },
          child: Text(label),
        ),
      ],
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: defaultDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    return picked;
  }
}
