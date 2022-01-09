import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late List<List?> _matrix;

  _HomePageState() {
    _initMatrix();
  }

  _initMatrix() {
    _matrix = List.filled(3, null, growable: false);
    for (var i = 0; i < _matrix.length; i++) {
      _matrix[i] = List.filled(3, null, growable: false);
      for (var j = 0; j < _matrix[i]!.length; j++) {
        _matrix[i]![j] = ' ';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1e1e1e),
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Крестики-Нолики',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 5,
                color: Color(0xFF569cd6),
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(15.0),
          child: SafeArea(
            child: Text(
              'автор: Меншиков Егор Витальевич\nшкола: №199 г.Минска, 7Г класс\nдата: 12.12.2021г\nдевиз: "Крестик-нолик" не сложен:\nесли не мы - то кто же?',
              style: TextStyle(
                letterSpacing: 2,
                color: Color(0xFFce9178),
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildElement(0, 0),
                    _buildElement(0, 1),
                    _buildElement(0, 2),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildElement(1, 0),
                    _buildElement(1, 1),
                    _buildElement(1, 2),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildElement(2, 0),
                    _buildElement(2, 1),
                    _buildElement(2, 2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _lastChar = 'O';

  _buildElement(int i, int j) {
    return GestureDetector(
      onTap: () {
        _changeMatrixField(i, j);

        if (_checkWinner(i, j)) {
          _showDialog(_matrix[i]![j]);
        } else {
          if (_checkDraw()) {
            _showDialog(null);
          }
        }
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: const Color(0xFF8f8f8f),
          ),
        ),
        child: Center(
          child: Text(
            _matrix[i]![j],
            style: const TextStyle(
              color: Color(0xFF6a9955),
              fontSize: 120,
            ),
          ),
        ),
      ),
    );
  }

  _changeMatrixField(int i, int j) {
    setState(() {
      if (_matrix[i]![j] == ' ') {
        if (_lastChar == 'O') {
          _matrix[i]![j] = 'X';
        } else {
          _matrix[i]![j] = 'O';
        }

        _lastChar = _matrix[i]![j];
      }
    });
  }

  _checkDraw() {
    var draw = true;
    for (var i in _matrix) {
      for (var j in i!) {
        if (j == ' ') draw = false;
      }
    }
    return draw;
  }

  _checkWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    var n = _matrix.length - 1;
    var player = _matrix[x]![y];

    for (int i = 0; i < _matrix.length; i++) {
      if (_matrix[x]![i] == player) col++;
      if (_matrix[i]![y] == player) row++;
      if (_matrix[i]![i] == player) diag++;
      if (_matrix[i]![n - i] == player) rdiag++;
    }
    if (row == n + 1 || col == n + 1 || diag == n + 1 || rdiag == n + 1) {
      return true;
    }
    return false;
  }

  _showDialog(String? winner) {
    String dialogText;
    if (winner == null) {
      dialogText = 'Это ничья Бро!';
    } else {
      dialogText = 'Играющий $winner-ками выиграл!';
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: const Text('Конец игры!'),
            titleTextStyle: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
            content: Text(
              dialogText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFffd700),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _initMatrix();
                  });
                },
                child: Text(
                  'ИГРАТЬ СНОВА',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          );
        });
  }
}
