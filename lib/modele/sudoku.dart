import 'dart:math';

import 'package:sudoku/constant.dart';

class Cell {
  final int index;
  late int i, j;
  bool isEmpty = true;
  bool isCorrect = true;
  bool isAnnotateMode = false;
  final int target;
  List<int> valuesToDisplay = [];
  Cell(
      {required this.index,
      required this.isEmpty,
      required this.target,
      required this.valuesToDisplay});

  void addToDisplay(int x) {
    valuesToDisplay.add(x);
  }

  void getIJFromIndex() {
    i = (index / 9).floor();
    j = index - 9 * i;
  }

  void init() {
    getIJFromIndex();
  }

  void setAnnotateMode() {
    isAnnotateMode = true;
  }

  void checkIsCorrect() {
    isCorrect = true;
    if (valuesToDisplay.length == 1) {
      isCorrect = (target == valuesToDisplay.first);
    }
    // print("is correct: $isCorrect");
  }
}

// void affiche(List<int> matrix) {
//   for (int i = 0; i < 9; i++) {
//     String s = '';
//     for (int j = 0; j < 9; j++) {
//       int index = j + 9 * i;
//       s += '${matrix[index]} ';
//     }
//     print(s);
//   }
// }

class Sudoku {
  List<Cell> cells = [];
  final String selectedDifficulty;
  Sudoku({required this.selectedDifficulty}) {
    List<int> sudokuInitial = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      7,
      8,
      9,
      1,
      2,
      3,
      4,
      5,
      6,
      4,
      5,
      6,
      7,
      8,
      9,
      1,
      2,
      3,
      9,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      6,
      7,
      8,
      9,
      1,
      2,
      3,
      4,
      5,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      1,
      2,
      8,
      9,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      5,
      6,
      7,
      8,
      9,
      1,
      2,
      3,
      4,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      1,
    ];
    List<int> shuffledMatrix = shuffleInitialMatrix(sudokuInitial);
    List<int> rowsShuffledMatrix = shuffleRowsAndCols(shuffledMatrix);
    List<int> matrix =
        createGrid(rowsShuffledMatrix, difficulty[selectedDifficulty]!);
    for (int idx = 0; idx < 81; idx++) {
      cells.add(
        Cell(
          index: idx,
          // isEmpty: (rowsShuffledMatrix[idx] == 0),
          // target: rowsShuffledMatrix[idx],
          // valuesToDisplay: [
          //   rowsShuffledMatrix[idx],
          // ],
          isEmpty: (matrix[idx] == 0),
          target: rowsShuffledMatrix[idx],
          valuesToDisplay: [
            matrix[idx],
          ],
        ),
      );
    }
  }
  List<int> createGrid(List<int> matrixIn, int nbInputs) {
    List<int> aux = List.from(matrixIn);
    List<int> indices = generateDistinctRandomInt(nbInputs, 80);
    for (int i = 0; i < nbInputs; i++) {
      aux[indices[i]] = 0;
    }
    return aux;
  }

  List<int> shuffleInitialMatrix(List<int> matrixIn) {
    List<int> aux = List.from(matrixIn);
    List<int> integers = List.generate(9, (index) => index + 1);
    integers.shuffle();
    Map<int, int> mapping = {for (int i = 1; i < 10; i++) i: integers[i - 1]};
    for (int i = 0; i < matrixIn.length; i++) {
      aux[i] = mapping[matrixIn[i]]!;
    }
    return aux;
  }

  List<int> shuffleRowsAndCols(List<int> matrixIn) {
    List<int> aux = List.from(matrixIn);
//swap rows
    Map<int, int> permutRows = {0: 1, 3: 4, 6: 7};
    int indexIn = 0, indexOut = 0;
    for (int idxRow in permutRows.keys) {
      for (int idx = 0; idx < 9; idx++) {
        indexIn = idxRow * 9;
        indexOut = permutRows[idxRow]! * 9;
        aux[indexIn + idx] = matrixIn[indexOut + idx];
        aux[indexOut + idx] = matrixIn[indexIn + idx];
      }
    }
//swap Cols
    Map<int, int> permutCols = {0: 2, 3: 5, 6: 8};
    for (int idxCol in permutCols.keys) {
      for (int idx = 0; idx < 9; idx++) {
        indexIn = idxCol + 9 * idx;
        indexOut = permutRows[idxCol]! + 9 * idx;
        aux[indexIn] = matrixIn[indexOut];
        aux[indexOut] = matrixIn[indexIn];
      }
    }
    return aux;
  }

  bool indexBelongsToSelectedIndexArea(int idx, int idxSelected) {
    bool res = false;
    int i, j, innerI, innerJ, innerIdx;
    int iSelected, jSelected, innerISelected, innerJSelected, innerIdxSelected;
    i = (idx / 9).floor();
    j = idx - 9 * i;
    innerI = (i / 3).floor();
    innerJ = (j / 3).floor();
    innerIdx = innerI + 3 * innerJ;

    iSelected = (idxSelected / 9).floor();
    jSelected = idxSelected - 9 * iSelected;
    innerISelected = (iSelected / 3).floor();
    innerJSelected = (jSelected / 3).floor();
    innerIdxSelected = innerISelected + 3 * innerJSelected;
    if ((i == iSelected) ||
        (j == jSelected) ||
        (innerIdx == innerIdxSelected)) {
      res = true;
    }
    return res;
  }

  bool check() {
    List<int> sumRows = List<int>.filled(9, 0);
    List<int> sumCols = List<int>.filled(9, 0);
    List<int> sumInnerSquares = List<int>.filled(9, 0);
    int i, j, innerI, innerJ, innerIdx;
    for (int idx = 0; idx < 81; idx++) {
      if ((cells[idx].isAnnotateMode) ||
          (cells[idx].valuesToDisplay.length > 1) ||
          (cells[idx].valuesToDisplay.first == 0)) {
        return false;
      }
      i = (idx / 9).floor();
      j = idx - 9 * i;
      innerI = (i / 3).floor();
      innerJ = (j / 3).floor();
      innerIdx = innerI + 3 * innerJ;
      sumRows[i] += cells[idx].valuesToDisplay.first;
      sumCols[j] += cells[idx].valuesToDisplay.first;
      sumInnerSquares[innerIdx] += cells[idx].valuesToDisplay.first;
    }
    // print("A la Fin:");
    // print("somme des lignes: $sumRows");
    // print("somme des colonnes: $sumCols");
    // print("somme des carres: $sumInnerSquares");
    if ((sumRows.where((element) => element == 45).length == 9) &&
        (sumCols.where((element) => element == 45).length == 9) &&
        (sumInnerSquares.where((element) => element == 45).length == 9)) {
      return true;
    } else {
      return false;
    }
  }
}

bool indexBelongsToColoredGrid(int idx) {
  int i = (idx / 9).floor();
  int j = idx - 9 * i;
  int innerI = (i / 3).floor();
  int innerJ = (j / 3).floor();
  int innerIdx = innerI + 3 * innerJ;
  bool aux = (innerIdx % 2 == 1);
  return aux;
}

List<int> generateDistinctRandomInt(int n, int nmax) {
  List<int> aux = [];
  var rand = Random();
  bool cont = (aux.length != n);
  while (cont) {
    int nextRand = 1 + rand.nextInt(nmax);
    if (!aux.contains(nextRand)) {
      aux.add(nextRand);
    }
    cont = (aux.length != n);
  }
  // print(aux);
  return aux;
}
