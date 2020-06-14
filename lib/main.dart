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
  List<int> _arr = [];
  int _sampleSize = 500;
  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;
  bool done = false;
  String _currentSortAlgo = 'BUBBLE';

  _setSortAlgo(String type) {
    setState(() {
      _generate();
      _currentSortAlgo = type;
    });
  }

  _generate() {
    _arr = [];
    for (int i = 0; i < _sampleSize; i++) {
      _arr.add(Random().nextInt(_sampleSize));
    }
    _streamController.add(_arr);
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<int>>();
    _stream = _streamController.stream;
    _generate();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  _sort() async {
    switch (_currentSortAlgo) {
      case 'BUBBLE':
        print('bubble');
        for (int i = 0; i < _arr.length - 1; i++) {
          for (int j = 0; j < _arr.length - i - 1; j++) {
            if (_arr[j] > _arr[j + 1]) {
              int temp = _arr[j];
              _arr[j] = _arr[j + 1];
              _arr[j + 1] = temp;
            }
            await Future.delayed(Duration(microseconds: 50));
            _streamController.add(_arr);
          }
        }
        print('done');
        break;
      case 'SELECTION':
        print('selection');
        for (int i = 0; i < _arr.length - 1; i++) {
          int min_index = i;
          for (int j = i + 1; j < _arr.length; j++) {
            if (_arr[j] < _arr[min_index]) {
              min_index = j;
            }
            int temp = _arr[min_index];
            _arr[min_index] = _arr[i];
            _arr[i] = temp;
          }
          await Future.delayed(Duration(microseconds: 1000));
          _streamController.add(_arr);
        }
        break;
      case 'MERGE':
        print('merge');
        _mergeSort(0, _sampleSize.toInt() - 1);
        break;
    }
  }

  _mergeSort(int leftIndex, int rightIndex) async {
    Future<void> merge(int leftIndex, int middleIndex, int rightIndex) async {
      int leftSize = middleIndex - leftIndex + 1;
      int rightSize = rightIndex - middleIndex;

      List leftList = new List(leftSize);
      List rightList = new List(rightSize);

      for (int i = 0; i < leftSize; i++) leftList[i] = _arr[leftIndex + i];
      for (int j = 0; j < rightSize; j++)
        rightList[j] = _arr[middleIndex + j + 1];
      int i = 0, j = 0;
      int k = leftIndex;
      while (i < leftSize && j < rightSize) {
        if (leftList[i] <= rightList[j]) {
          _arr[k] = leftList[i];
          i++;
        } else {
          _arr[k] = rightList[j];
          j++;
        }
        await Future.delayed((Duration(microseconds: 200)));
        _streamController.add(_arr);
        k++;
      }
      while (i < leftSize) {
        _arr[k] = leftList[i];
        i++;
        k++;
        await Future.delayed((Duration(microseconds: 200)));
        _streamController.add(_arr);
      }
      while (j < rightSize) {
        _arr[k] = rightList[j];
        j++;
        k++;
        await Future.delayed((Duration(microseconds: 200)));
        _streamController.add(_arr);
      }
    }

    if (leftIndex < rightIndex) {
      int middleIndex = (rightIndex + leftIndex) ~/ 2;
      await _mergeSort(leftIndex, middleIndex);
      await _mergeSort(middleIndex + 1, rightIndex);
      await Future.delayed(Duration(microseconds: 50));
      _streamController.add(_arr);
      await merge(leftIndex, middleIndex, rightIndex);
    }
  }


  _mergesort(ar) {
    if (ar.length > 1) {
      int mid = (ar.length / 2).round();
      List<int> left = ar.sublist(0, mid);
      List<int> right = ar.sublist(mid, _arr.length);
      _mergesort(left);
      _mergesort(right);
      int i = 0, j = 0, k = 0;
      while (i < left.length && j < right.length) {
        if (left[i] < right[j]) {
          ar[k] = left[i];
          i += 1;
        } else {
          ar[k] = right[j];
          j += 1;
        }
        k += 1;
      }
      while (i < left.length) {
        ar[k] = left[i];
        i += 1;
        k += 1;
      }
      while (i < right.length) {
        ar[k] = right[j];
        j += 1;
        k += 1;
      }
      print(ar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[200],
        appBar: AppBar(
          title: Text(
            _currentSortAlgo + ' SORT',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w300, fontSize: 22),
          ),
          actions: [
            PopupMenuButton<String>(
              initialValue: 'BUBBLE',
              color: Colors.blueGrey[800],
              tooltip: 'Select an Algorithm',
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'BUBBLE',
                    child: Text(
                      'Bubble Sort',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'SELECTION',
                    child: Text(
                      'Selection Sort',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'MERGE',
                    child: Text(
                      'Merge Sort',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ];
              },
              onSelected: (String value) {
                _setSortAlgo(value);
              },
            )
          ],
          backgroundColor: Colors.blueGrey[900],
        ),
        body: Container(
          child: StreamBuilder<Object>(
              stream: _stream,
              builder: (context, snapshot) {
                int counter = 0;
                return Row(
                    children: _arr.map((int number) {
                  counter++;
                  return CustomPaint(
                    painter: ContainerPainter(
                        width: MediaQuery.of(context).size.width / _sampleSize,
                        value: number,
                        index: counter,
                        samplesize: _sampleSize),
                  );
                }).toList());
              }),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: _generate,
                  child: Text(
                    'GENERATE ARRAY',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  child: Text(
                    'SORT',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                  onPressed: _sort,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerPainter extends CustomPainter {
  final double width;
  final int value, index, samplesize;

  ContainerPainter({this.width, this.value, this.index, this.samplesize});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    if (this.value < samplesize * .10) {
      paint.color = Colors.blue[100].withOpacity(0.7);
    } else if (this.value < samplesize * .20) {
      paint.color = Colors.blue[300].withOpacity(0.4);
    } else if (this.value < samplesize * .30) {
      paint.color = Colors.blue[200];
    } else if (this.value < samplesize * .40) {
      paint.color = Colors.blue[300];
    } else if (this.value < samplesize * .50) {
      paint.color = Colors.blue[400];
    } else if (this.value < samplesize * .60) {
      paint.color = Colors.blue[500];
    } else if (this.value < samplesize * .70) {
      paint.color = Colors.blue[600];
    } else if (this.value < samplesize * .80) {
      paint.color = Colors.blue[700];
    } else if (this.value < samplesize * .90) {
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
