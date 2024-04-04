import 'package:flutter/material.dart';

const seedColor = Colors.amber;
const brightness = Brightness.light;

// Color cellSelectionColor = Colors.green[100]!;
// Color cellInnerBgColor = Colors.yellow[100]!;
// Color cellOuterBgColor = Colors.white;
// Color highlightRowColColor = Colors.orange[100]!;
Color cellBorderColor = Colors.black12;
Color cellErrorColor = Colors.red[100]!;

Color getCellOuterBgColor(BuildContext context) {
  return Theme.of(context).colorScheme.secondaryContainer;
}

Color getCellInnerBgColor(BuildContext context) {
  // return Colors.white;
  return Theme.of(context).colorScheme.primaryContainer;
}

Color getCellSelectionColor(BuildContext context) {
  return Theme.of(context).colorScheme.tertiaryContainer;
}

Color getInputNumberColor(BuildContext context) {
  return Theme.of(context).colorScheme.surfaceVariant;
}

TextStyle cellMultiInputTextSize =
    const TextStyle(fontSize: 10, fontStyle: FontStyle.italic);
TextStyle legendStyle = const TextStyle(fontSize: 12);
TextStyle emptyCellTextStyle =
    const TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
TextStyle stickyCellTextStyle =
    const TextStyle(fontSize: 30, fontWeight: FontWeight.w300);

const Map<String, int> difficulty = {
  "débutant": 20,
  "intermédiaire": 30,
  "confirmé": 40,
  "expert": 50,
  "diabolique": 60,
};
