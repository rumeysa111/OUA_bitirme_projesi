import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.brown,
    ),
    home: Scaffold(
      body: RandomCoffeeTab(),
    ),
  ));
}

class RandomCoffeeTab extends StatefulWidget {
  const RandomCoffeeTab({Key? key}) : super(key: key);

  @override
  _RandomCoffeeTabState createState() => _RandomCoffeeTabState();
}

class _RandomCoffeeTabState extends State<RandomCoffeeTab> {
  final List<String> coffeeList = [
    'Filtre Kahve',
    'Cold Brew',
    'Americano',
    'Lungo',
    'Espresso',
    'Doppio',
    'Ristretto',
    'Latte',
    'Caffè Latte',
    'Latte Macchiato',
    'Breve',
    'Iced Latte',
    'Iced Caffè Latte',
    'Iced Latte Macchiato',
    'Iced Breve',
    'Iced Mocha',
    'Frappe',
    'Cappuccino',
    'Flat White',
    'Caramel Macchiato',
    'Hazelnut Latte',
    'Vanilla Latte',
    'White Chocolate Mocha',
    'Caramel Latte',
    'Irish Nut Creme',
    'Iced Caramel Macchiato',
    'Iced Hazelnut Latte',
    'Iced Vanilla Latte',
    'Iced White Chocolate Mocha',
    'Iced Caramel Latte',
    'Iced Irish Nut Creme',
    'Iced Sweet Americano',
    'Iced Sweet Espresso',
    'Iced Americano',
    'Nitro Cold Brew',
    'Shakerato',
    'Chemex',
    'French Press',
    'AeroPress',
    'Siphon Coffee',
    'Moka Pot',
    'Türk Kahvesi',
    'Café Cubano',
    'Vienna Coffee',
    'Affogato',
    'Mazagran',
    'Bulletproof Coffee'
  ];

  final StreamController<int> _selected = StreamController<int>();
  Timer? _timer;
  bool isSpinning = false;
  int lastSelectedIndex = 0;

  @override
  void dispose() {
    _selected.close();
    super.dispose();
  }

  void spin() {
    if (!isSpinning) {
      isSpinning = true;
      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        final random = Random();
        lastSelectedIndex = random.nextInt(coffeeList.length);
        _selected.add(lastSelectedIndex);
      });
    }
  }

  void stop() {
    if (isSpinning) {
      _timer?.cancel();
      isSpinning = false;
      showSelectedCoffee();
    }
  }

  void showSelectedCoffee() {
    final selectedCoffee = coffeeList[lastSelectedIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seçilen Kahve'),
        content: Text('Önerilen Kahve: $selectedCoffee'),
        actions: <Widget>[
          TextButton(
            child: Text('Tamam',),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sürpriz Kahve Seç'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FortuneWheel(
              selected: _selected.stream,
              items: name(),
              indicators: <FortuneIndicator>[
                FortuneIndicator(
                  alignment: Alignment.topCenter,
                  child: TriangleIndicator(
                    color: Colors.brown,
                  ),
                ),
              ],
              onFling: () {
                spin();
                Future.delayed(Duration(seconds: 2), () {
                  stop();
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: spin,
                child: Text('Döndür',  style: TextStyle(color: Colors.black)),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: stop,
                child: Text('Durdur',
                style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<FortuneItem> name() {
    List<Color> brownShades = [
      Colors.brown[100]!,
      Colors.brown[200]!,
      Colors.brown[300]!,
      Colors.brown[400]!,
      Colors.brown[500]!,
      Colors.brown[600]!,
      Colors.brown[700]!,
      Colors.brown[800]!,
      Colors.brown[900]!,
    ];

    List<FortuneItem> listem = coffeeList
        .asMap()
        .entries
        .map((entry) => FortuneItem(
      child: Text(entry.value),
      style: FortuneItemStyle(
        color: brownShades[entry.key % brownShades.length],
        borderColor:Colors.brown,
        borderWidth: 1.0,
      ),
    ))
        .toList();
    shuffleList(listem);
    return listem;
  }

  void shuffleList(List list) {
    final random = Random();
    for (int i = list.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      var temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }
}
