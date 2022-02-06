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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // IconButton(onPressed: _incrementCounter, icon: icon)
        ],
      ),
      body: Center(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
    final result = await Navigator.push(context, _dialogBuilder(context));
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
