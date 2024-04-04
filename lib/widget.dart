import 'package:flutter/material.dart';

import 'constant.dart';
import 'modele/sudoku.dart';

class InputDigit extends StatelessWidget {
  const InputDigit({
    super.key,
    required this.digitAsString,
    required this.color,
  });
  final String digitAsString;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Card(
        color: color, // color: Theme.of(context).colorScheme.tertiaryContainer,
        // surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: Text(
            digitAsString,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}

Color getColorCell(int index, int selectedIndex, bool isError, bool isMulti,
    BuildContext context) {
  Color aux = Colors.white;

  if (index == selectedIndex) {
    aux = getCellSelectionColor(context);
  } else {
    aux = indexBelongsToColoredGrid(index)
        ? getCellOuterBgColor(context)
        : getCellInnerBgColor(context);
  }
  if ((!isMulti) && (isError)) aux = cellErrorColor;

  return aux;
}
