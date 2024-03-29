import 'package:flutter/material.dart';
import 'package:sudoku/constant.dart';
import 'package:sudoku/modele/sudoku.dart';
import 'package:sudoku/widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // colorSchemeSeed: seedColor,
          colorScheme: ColorScheme.fromSeed(seedColor: seedColor)
          // .copyWith(surface: surfaceColor)
          ,
          brightness: brightness,
          useMaterial3: true),
      home: const MyHomePage(title: 'Sudoku'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Sudoku sudoku;
  late int selectedIdx;
  String isValid = ' ';
  String selectedDifficulty = difficulty.keys.first;

  void initializeSelectedIdx() {
    selectedIdx =
        sudoku.cells.indexWhere((cell) => cell.valuesToDisplay.first == 0);
  }

  @override
  void initState() {
    super.initState();
    selectedDifficulty = difficulty.keys.first;
    sudoku = Sudoku(selectedDifficulty: selectedDifficulty);
    initializeSelectedIdx();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          GridView.count(
            padding: const EdgeInsets.all(10.0),
            crossAxisCount: 9,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(81, (index) {
              Cell currentCell = sudoku.cells[index];
              return InkWell(
                onTap: () {
                  currentCell.isEmpty
                      ? setState(() {
                          selectedIdx = index;
                        })
                      : null;
                },
                onLongPress: () {
                  currentCell.isEmpty
                      ? setState(() {
                          selectedIdx = index;
                          currentCell.valuesToDisplay = [0];
                          currentCell.isCorrect = true;
                        })
                      : null;
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: getColorCell(index, selectedIdx,
                            !currentCell.isCorrect, context),
                        border: Border.all(color: cellBorderColor)),
                    child: (currentCell.valuesToDisplay.length == 1)
                        ? Text(
                            (currentCell.valuesToDisplay.first == 0)
                                ? ''
                                : currentCell.valuesToDisplay.first.toString(),
                            style: currentCell.isEmpty
                                ? emptyCellTextStyle
                                : stickyCellTextStyle,
                          )
                        : GridView.count(
                            crossAxisCount:
                                currentCell.valuesToDisplay.length >= 5 ? 3 : 2,
                            children: currentCell.valuesToDisplay
                                .map(
                                  (e) => Text(
                                    e.toString(),
                                    style: cellMultiInputTextSize,
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ),
              );
            }),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: List.generate(
          //       9,
          //       (index) => InkWell(
          //             onTap: () {
          //               setState(() {
          //                 Cell currentCell = sudoku.cells[selectedIdx];
          //                 currentCell.valuesToDisplay.remove(0);
          //                 if ((!currentCell.valuesToDisplay
          //                     .contains(index + 1))) {
          //                   currentCell.valuesToDisplay.add(index + 1);
          //                 }
          //                 currentCell.checkIsCorrect();
          //               });
          //             },
          //             child: InputDigit(
          //                 color: getInputNumberColor(context),
          //                 digitAsString: (index + 1).toString()),
          //           )),
          // ),
          GridView.count(
            crossAxisCount: 5,
            padding: const EdgeInsets.all(10.0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(
              9,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    Cell currentCell = sudoku.cells[selectedIdx];
                    currentCell.valuesToDisplay.remove(0);
                    if ((!currentCell.valuesToDisplay.contains(index + 1))) {
                      currentCell.valuesToDisplay.add(index + 1);
                    }
                    currentCell.checkIsCorrect();
                  });
                },
                child: InputDigit(
                  color: getInputNumberColor(context),
                  digitAsString: (index + 1).toString(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  setState(() {
                    sudoku = Sudoku(selectedDifficulty: selectedDifficulty);
                    initializeSelectedIdx();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit_note),
                onPressed: () {},
              ),
              DropdownButton(
                value: selectedDifficulty,
                items: difficulty.keys
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value!;
                    // print(selectedDifficulty);
                    sudoku = Sudoku(selectedDifficulty: selectedDifficulty);
                    initializeSelectedIdx();
                  });
                },
              ),
              // TextButton(
              //     onPressed: () {
              //       // print(sudoku.check());
              //       setState(() {
              //         isValid = sudoku.check()
              //             ? 'grille correcte'
              //             : 'grille incorrecte';
              //       });
              //     },
              //     child: Text('vérification: $isValid')),
            ],
          ),
        ]),
      ),
    );
  }
}

// class myCard extends StatelessWidget {
//   const myCard({
//     super.key,
//     required this.selectedIdx,
//     required this.sudoku,
//   });

//   final int selectedIdx;
//   final Sudoku sudoku;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//       surfaceTintColor: selectedIdx == index ? Colors.purple : Colors.blue,
//       child: Padding(
//         padding: const EdgeInsets.all(0.0),
//         child: Column(
//           children: sudoku.cells[index].valuesToDisplay
//               .map((e) => Text(
//                     e == null ? '' : e.toString(),
//                     style: TextStyle(
//                         fontSize:
//                             sudoku.cells[index].valuesToDisplay.length == 1
//                                 ? 20
//                                 : 10),
//                   ))
//               .toList(),
//           // [
//           //   Text(
//           //     sudoku.cells[index].valuesToDisplay.first.toString(),
//           //   ),
//           // ],
//         ),
//       ),
//     );
//   }
// }
