import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Res {
  const Res({this.row = 0, this.col = 0, this.result = ""});
  final int row;
  final int col;
  final String result;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int rows = 0;
  int columns = 0;

  final List<List<String>> _data = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['7', '8', '9'],
    ['7', '8', '9'],
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          // IconButton(onPressed: _incrementCounter, icon: icon)
        ],
      ),
      body: Center(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: DynamicTable(
                data: _data,
                onChanged: (el) => {
                      if (el.result != "")
                        {
                          setState(() {
                            _data[el.row][el.col] = el.result;
                          })
                        }
                    })),
      ),
      // persistentFooterButtons: [
      //   IconButton(
      //     icon: const Icon(Icons.add_box),
      //     tooltip: "Add Column",
      //     onPressed: () {
      //       setState(() {
      //         columns++;
      //       });
      //     },
      //   ),
      //   IconButton(
      //     icon: const Icon(Icons.add_box_outlined),
      //     tooltip: "Add row",
      //     onPressed: () {
      //       setState(() {
      //         rows++;
      //       });
      //     },
      //   ),
      //   IconButton(
      //     icon: const Icon(Icons.remove_circle),
      //     tooltip: "Remove Column",
      //     onPressed: () {
      //       if (columns == 1) {
      //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //           content: Text("Cannot remove last column"),
      //           duration: Duration(seconds: 2),
      //         ));
      //       } else {
      //         setState(() {
      //           columns--;
      //         });
      //       }
      //     },
      //   ),
      //   IconButton(
      //     icon: const Icon(Icons.remove_circle_outline),
      //     tooltip: "Remove row",
      //     onPressed: () {
      //       if (rows == 1) {
      //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //           content: Text("Cannot remove last row"),
      //           duration: Duration(seconds: 2),
      //         ));
      //       } else {
      //         setState(() {
      //           rows--;
      //         });
      //       }
      //     },
      //   ),
      // ],
      drawer: const Drawer(
        child: Text("gfdgdfg"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DynamicColumn extends StatelessWidget {
  DynamicColumn(
      {Key? key,
      required this.text,
      required this.row,
      required this.column,
      required this.onChange})
      : super(key: key);

  final String text;

  final ValueChanged<Res> onChange;

  final int row;

  final int column;

  final myController = TextEditingController();

  Route<Object?> _dialogBuilder(BuildContext context) {
    String value = "";
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('AlertDialog Title'),
        content: TextField(
          onChanged: (text) {
            value = text;
          },
          controller: myController,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, ""),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, value),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        _dialogBuilder(context));
    // return result;
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
    onChange(Res(row: row, col: column, result: result.toString()));
  }

  @override
  Widget build(BuildContext context) {
    myController.text = text;
    return Container(
        height: 32,
        color: Colors.green,
        child: Center(
          child: TextButton(
            onPressed: () => _navigateAndDisplaySelection(context),
            child: Text(
              text,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ));
  }
}

class DynamicTable extends StatelessWidget {
  const DynamicTable({Key? key, required this.data, required this.onChanged})
      : super(key: key);

  final List<List<String>> data;

  final ValueChanged<Res> onChanged;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: List.generate(data.length, (i) {
        return TableRow(
          children: List.generate(data[i].length, (j) {
            return DynamicColumn(
              text: data[i][j],
              row: i,
              column: j,
              onChange: onChanged,
            );
          }),
        );
      }),
    );
  }
}
