import 'package:flutter/material.dart';

class Typography1 extends StatelessWidget {
  final String value;
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;

  const Typography1(
      {required this.label,
      required this.value,
      this.labelStyle,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$label: ',
            style: labelStyle,
          ),
          Flexible(
            child: Text(
              softWrap: true,
              value,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class Typography2 extends StatelessWidget {
  final String value;
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;

  const Typography2(
      {required this.label,
      required this.value,
      this.labelStyle,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          '$label:',
          style: labelStyle ?? const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8), // Add some space between label and value
        Expanded(
          child: Baseline(
            baseline: 0.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              value,
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}

class RowWithLabelAndValueSet extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;
  bool isOverflow = false;

  RowWithLabelAndValueSet(
      {required this.label1,
      required this.value1,
      required this.label2,
      required this.value2,
      this.isOverflow = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: RowWithLabelAndValue(
              label: label1, value: value1, isOverflow: isOverflow),
        ),
        // Add space between RowWithLabelAndValue widgets
        Expanded(
          child: RowWithLabelAndValue(
              label: label2, value: value2, isOverflow: isOverflow),
        ),
      ],
    );
  }
}

class RowWithLabelAndValue extends StatelessWidget {
  final String label;
  final String value;
  bool isOverflow = false;

  RowWithLabelAndValue(
      {required this.label, required this.value, this.isOverflow = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 1), // Add some space between label and value
        Expanded(
          child: Baseline(
            baseline: 0.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              value,
              overflow: isOverflow ? TextOverflow.ellipsis : null,
            ),
          ),
        ),
      ],
    );
  }
}
