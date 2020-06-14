import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SORTING',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _numbers = [];
  int _sampleSize = 500;
  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;

  _randomise() {
    _numbers = [];
    for (int i = 0; i < _sampleSize; i++) {
      _numbers.add(Random().nextInt(_sampleSize));
    }
    // setState(() {});
    _streamController.add(_numbers);
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<int>>();
    _stream = _streamController.stream;
    _randomise();
  }

  _sort() async {
    for (int i = 0; i < _numbers.length - 1; i++) {
      for (int j = 0; j < _numbers.length - i - 1; j++) {
        if (_numbers[j] > _numbers[j + 1]) {
          int temp = _numbers[j];
          _numbers[j] = _numbers[j + 1];
          _numbers[j + 1] = temp;
        }
        await Future.delayed(Duration(microseconds: 100));
        // setState(() {});
        _streamController.add(_numbers);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.lightBlueAccent[100].withOpacity(0.3),
        appBar: AppBar(
          title: Center(
              child: Text(
            'SORTING',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22),
          )),
          backgroundColor: Colors.blue[900],
        ),
        body: Container(
          child: StreamBuilder<Object>(
              stream: _stream,
              builder: (context, snapshot) {
                int counter = 0;
                return Row(
                    children: _numbers.map((int number) {
                  counter++;
                  return CustomPaint(
                    painter: ContainerPainter(
                        width: MediaQuery.of(context).size.width / _sampleSize,
                        value: number,
                        index: counter),
                  );
                }).toList());
              }),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: _randomise,
                  child: Text(
                    'GENERATE ARRAY',
                    style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  child: Text(
                    'SORT',
                    style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300),
                  ),
                  onPressed: _sort,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerPainter extends CustomPainter {
  final double width;
  final int value, index;

  ContainerPainter({this.width, this.value, this.index});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    if (this.value < 500 * .10) {
      paint.color = Colors.blue[100];
    } else if (this.value < 500 * .20) {
      paint.color = Colors.blue[200].withOpacity(0.7);
    } else if (this.value < 500 * .30) {
      paint.color = Colors.blue[200];
    } else if (this.value < 500 * .40) {
      paint.color = Colors.blue[300];
    } else if (this.value < 500 * .50) {
      paint.color = Colors.blue[400];
    } else if (this.value < 500 * .60) {
      paint.color = Colors.blue[500];
    } else if (this.value < 500 * .70) {
      paint.color = Colors.blue[600];
    } else if (this.value < 500 * .80) {
      paint.color = Colors.blue[700];
    } else if (this.value < 500 * .90) {
      paint.color = Colors.blue[800];
    } else {
      paint.color = Colors.blue[900];
    }
    paint.strokeWidth = width;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, value.ceilToDouble()), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
