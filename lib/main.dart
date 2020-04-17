import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Am I Loud?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _maxCounter = 0;

  void _clearCounter() {
    setState(() {
      _counter = 0;
      _maxCounter = 0;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _maxCounter = max(_counter, _maxCounter);
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  Color getColor(number, weight) {
    if (number < 0.5) {
      return Colors.blueGrey[200];
    }
    if (number < 0.75) {
      return Colors.yellow[weight];
    }
    return Colors.red[weight];
  }

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
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1 +
                      250.0,
                ),
                decoration: BoxDecoration(
                    color: getColor(_counter / 20, 100),
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: getColor(_maxCounter / 20, 200),
                      width: 4.0,
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'The counter is at:',
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.display1,
                    ),
                    Text(
                      'The max value of the counter so far is:',
                    ),
                    Text(
                      '$_maxCounter',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ],
                ),
              ),
            ]),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _clearCounter,
            tooltip: 'Clear',
            child: Icon(Icons.clear),
            heroTag: null,
          ), // This trailing comma makes auto-formatting nicer for build methods.
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
            heroTag: null,
          ), // This trailing comma makes auto-formatting nicer for build methods.
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: Icon(Icons.remove),
            heroTag: null,
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ],
      ),
    );
  }
}
