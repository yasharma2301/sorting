import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting',
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
  bool disabled = false;
  int _sampleSize = 200;
  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;
  bool done = false;
  String _currentSortAlgo = 'MERGE';

  _generate() {
    setState(() {
      _arr = [];
    });
    for (int i = 0; i < _sampleSize; i++) {
      _arr.add(Random().nextInt(_sampleSize));
    }
    _streamController.add(_arr);
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<int>>.broadcast();
    _stream = _streamController.stream;
    _generate();
  }

  @override
  void dispose() {
    if(mounted){
      print('mounted');
    } else{
      print('un mount');
    }
    _streamController.close();

    super.dispose();
  }

  _sort() async {
    switch (_currentSortAlgo) {
      case 'BUBBLE':
        print('bubble');
        setState(() {
          disabled = true;
        });
        for (int i = 0; i < _arr.length - 1; i++) {
          for (int j = 0; j < _arr.length - i - 1; j++) {
            if (_arr[j] > _arr[j + 1]) {
              int temp = _arr[j];
              _arr[j] = _arr[j + 1];
              _arr[j + 1] = temp;
            }
            await Future.delayed(Duration(microseconds: 1));
            _streamController.add(_arr);
          }
        }
        setState(() {
          disabled = false;
        });
        break;
      case 'SELECTION':
        print('selection');
        setState(() {
          disabled = true;
        });
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
        setState(() {
          disabled = false;
        });
        break;
      case 'MERGE':
        print('merge');
        setState(() {
          disabled = true;
        });
        _mergeSort(0, _sampleSize.toInt() - 1).then((value) => setState(() {
              disabled = false;
            }));

        break;
    }
  }

  Future<void> _mergeSort(int leftIndex, int rightIndex) async {
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

  List<Widget> _actions() {
    return [
      RepaintBoundary(
        child: Slider(
            value: _sampleSize + 0.0,
            min: 50,
            max: 200,
            onChanged: disabled
                ? null
                : (double value) {
                    _generate();
                    setState(() {
                      _sampleSize = value.round();
                    });
                    _generate();

            }),
      ),
      ActionButton(
        onPressedCallback: _generate,
        text: 'GENERATE ARRAY',
        disabled: disabled,
      ),
      ActionButton(
        onPressedCallback: _sort,
        text: 'SORT',
        disabled: disabled,
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(color: disabled?Colors.black54:Colors.white, width: 1),
              borderRadius: BorderRadius.circular(2)),
          child: DropdownButton<String>(
            value: _currentSortAlgo,
            underline: SizedBox(),
            dropdownColor: Colors.blueGrey[900],
            items: <String>['MERGE', 'SELECTION', 'BUBBLE'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value + ' SORT',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            onChanged: disabled
                ? null
                : (String value) {
                    setState(() {
                      _currentSortAlgo = value;
                    });
                  },
          ),
        ),
      ),
      ActionButton(
        onPressedCallback: () {
          html.window
              .open('https://github.com/yasharma2301/sorting', 'new tab');
        },
        text: 'CODE',
        disabled: false,
      ),
    ];
  }

  List<Widget> _drawerActions() {
    return [
      SizedBox(height: 20,),
      Text(
        'Controls',
        style: TextStyle(color: Colors.white,fontSize: 18),
      ),
      ActionButton(
        onPressedCallback: _generate,
        text: 'GENERATE ARRAY',
        disabled: disabled,
      ),
      ActionButton(
        onPressedCallback: _sort,
        text: 'SORT',
        disabled: disabled,
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(2)),
          child: DropdownButton<String>(
            value: _currentSortAlgo,
            underline: SizedBox(),
            dropdownColor: Colors.blueGrey[900],
            items: <String>['MERGE', 'SELECTION', 'BUBBLE'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value + ' SORT',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: disabled
                ? null
                : (String value) {
              setState(() {
                _currentSortAlgo = value;
              });
            },
          ),
        ),
      ),
      ActionButton(
        onPressedCallback: () {
          html.window
              .open('https://github.com/yasharma2301/sorting', 'new tab');
        },
        text: 'CODE',
        disabled: false,
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        return Container(
          color: Colors.blueAccent,
          child: Scaffold(
            key: _scaffoldKey,
            endDrawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.blueGrey[900]
              ),
              child:Drawer(
                child: Column(
                  children: _drawerActions(),
                ),
              ),
            ),
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: Text(
                'Sorting Visualizer',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 22),
              ),
              actions: (constraints.maxWidth <= 900)
                  ? [
                      ActionButton(
                        onPressedCallback: () {
                          _scaffoldKey.currentState.openEndDrawer();
                        },
                        text: 'Options',
                        disabled: false,
                      )
                    ]
                  : _actions(),
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
                            width:
                                MediaQuery.of(context).size.width / _sampleSize,
                            value: number,
                            index: counter,
                            samplesize: _sampleSize),
                      );
                    }).toList());
                  }),
            ),
          ),
        );
      },
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
      paint.color = Colors.blue[100];
    } else if (this.value < samplesize * .20) {
      paint.color = Colors.blue[200];
    } else if (this.value < samplesize * .30) {
      paint.color = Colors.blue[300];
    } else if (this.value < samplesize * .40) {
      paint.color = Colors.blue[400];
    } else if (this.value < samplesize * .50) {
      paint.color = Colors.blue[500];
    } else if (this.value < samplesize * .60) {
      paint.color = Colors.blue[600];
    } else if (this.value < samplesize * .70) {
      paint.color = Colors.blue[700];
    } else if (this.value < samplesize * .80) {
      paint.color = Colors.blue[800];
    } else if (this.value < samplesize * .90) {
      paint.color = Colors.indigo;
    } else {
      paint.color = Colors.blue[900];
    }
    paint.strokeWidth = width;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, value.ceilToDouble() * 2.5), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ActionButton extends StatefulWidget {
  final onPressedCallback, text, disabled;

  const ActionButton(
      {Key key, this.onPressedCallback, this.text, this.disabled})
      : super(key: key);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: RaisedButton(
        onPressed: widget.disabled ? null : widget.onPressedCallback,
        color: widget.disabled ? Colors.redAccent : Colors.white,
        elevation: 10,
        hoverElevation: 5,
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.disabled ? Colors.white : Colors.blueGrey[900],
            ),
          ),
        ),
      ),
    );
  }
}

//Padding(
//padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//child: Container(
//decoration: BoxDecoration(
//border: Border.all(color: Colors.white, width: 1)),
//child: Center(
//child: Row(
//mainAxisAlignment: MainAxisAlignment.center,
//crossAxisAlignment: CrossAxisAlignment.center,
//children: [
//Text(_currentSortAlgo + ' SORT'),
//PopupMenuButton<String>(
//initialValue: 'MERGE',
//color: Colors.blueGrey[800],
//tooltip: 'Select an Algorithm',
//itemBuilder: (context) {
//return [
//PopupMenuItem(
//value: 'BUBBLE',
//child: Text(
//'Bubble Sort',
//style: TextStyle(color: Colors.white),
//),
//),
//PopupMenuItem(
//value: 'SELECTION',
//child: Text(
//'Selection Sort',
//style: TextStyle(color: Colors.white),
//),
//),
//PopupMenuItem(
//value: 'MERGE',
//child: Text(
//'Merge Sort',
//style: TextStyle(color: Colors.white),
//),
//),
//];
//},
//onSelected: (String value) {
//_setSortAlgo(value);
//},
//),
//],
//),
//),
//),
//),
