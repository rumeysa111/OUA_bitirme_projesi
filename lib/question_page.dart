import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'recommendation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int _currentQuestionIndex = 0;
  final List<String> _answers = [];
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Özel bir demleme çeşidi tercih eder misiniz?',
      'options': ['Evet', 'Hayır'],
    },
    {
      'question': 'Kahvenizi nasıl içmek istersiniz?',
      'options': ['Sıcak', 'Soğuk'],
    },
    {
      'question': 'Tatlı kahveleri sever misiniz?',
      'options': ['Evet', 'Hayır'],
    },
    {
      'question': 'Kahvenizde süt kullanır mısınız?',
      'options': ['Evet', 'Hayır'],
      'note': 'Vegan ya da vejetaryen süt tercihiniz varsa lütfen baristaya belirtiniz.',
    },
    {
      'question': 'Kahvenizde aromalı şuruplar ister misiniz?',
      'options': ['Evet', 'Hayır'],
    },
    {
      'question': 'Kahvenizin yoğunluğunu nasıl seversiniz?',
      'options': ['Hafif', 'Orta', 'Yoğun'],
    },
  ];

  final Map<String, List<String>> _coffeeCategories = {
    'Filtre Kahve': ['Filtre Kahve'],
    'Soğuk Filtre Kahve': ['Cold Brew'],
    'Sade Kahveler': ['Americano', 'Lungo'],
    'Espresso Tabanlı Kahveler': ['Espresso', 'Doppio', 'Ristretto'],
    'Sütlü Kahveler': ['Latte', 'Caffè Latte', 'Latte Macchiato', 'Breve'],
    'Soğuk Sütlü Kahveler': ['Iced Latte', 'Iced Caffè Latte', 'Iced Latte Macchiato', 'Iced Breve'],
    'Tatlı Soğuk Sütlü Kahveler': ['Iced Mocha', 'Frappe'],
    'Sert Sütlü Kahveler': ['Cappuccino', 'Flat White'],
    'Tatlı ve Aromalı Kahveler': [
      'Caramel Macchiato',
      'Hazelnut Latte',
      'Vanilla Latte',
      'White Chocolate Mocha',
      'Caramel Latte',
      'Irish Nut Creme'
    ],
    'Soğuk Tatlı ve Aromalı Kahveler': [
      'Iced Caramel Macchiato',
      'Iced Hazelnut Latte',
      'Iced Vanilla Latte',
      'Iced White Chocolate Mocha',
      'Iced Caramel Latte',
      'Iced Irish Nut Creme'
    ],
    'Soğuk Tatlı ve Sütsüz Kahveler': [
      'Cold Brew with Sweet Syrup',
      'Iced Sweet Americano',
      'Iced Sweet Espresso'
    ],
    'Soğuk Kahveler': ['Iced Americano', 'Nitro Cold Brew', 'Shakerato'],
    'Demleme Yöntemlerine Göre Kahveler': [
      'Chemex',
      'French Press',
      'AeroPress',
      'Siphon Coffee',
      'Moka Pot'
    ],
    'Özel ve Yerel Kahveler': [
      'Türk Kahvesi',
      'Café Cubano',
      'Vienna Coffee',
      'Affogato',
      'Mazagran',
      'Bulletproof Coffee'
    ],
    'Şuruplu Kahveler': [
      'Caramel Macchiato',
      'Caramel Latte',
      'Vanilla Latte',
      'Hazelnut Latte',
      'Irish Nut Creme',
      'White Chocolate Mocha'
    ]
  };

  void _saveCoffeeSelection(String coffee) {
    FirebaseFirestore.instance.collection('coffee_selections').add({
      'coffee': coffee,
      'answers': _answers,
      'timestamp': Timestamp.now(),
    }).then((docRef) {
      print('Kahve seçimi kaydedildi: $docRef');
    }).catchError((error) {
      print('Kahve seçimi kaydedilemedi: $error');
    });
  }

  void _nextQuestion(String answer) {
    setState(() {
      _answers.add(answer);

      if (_currentQuestionIndex == 0 && answer == 'Evet') {
        String recommendedCoffee = _getBrewMethodRecommendation();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecommendationPage(
              coffee: recommendedCoffee,
              resetCallback: _resetQuestions,
              answers: _answers, // Yanıtları da geçiyoruz
            ),
          ),
        );
      } else if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        _showRecommendation();
      }
    });
  }

  String _getBrewMethodRecommendation() {
    List<String> brewMethods = _coffeeCategories['Demleme Yöntemlerine Göre Kahveler']!;
    return brewMethods[Random().nextInt(brewMethods.length)];
  }

  void _showRecommendation() {
    String category = _getCategory();
    List<String> coffeeList = _coffeeCategories[category]!;
    String recommendedCoffee = coffeeList[Random().nextInt(coffeeList.length)];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationPage(
          coffee: recommendedCoffee,
          resetCallback: _resetQuestions,
          answers: [],
        ),
      ),
    );
  }

  String _getCategory() {
    bool prefersMilk = _answers[_questions.indexWhere((q) => q['question'] == 'Kahvenizde süt kullanır mısınız?')] == 'Evet';
    bool likesSweet = _answers[_questions.indexWhere((q) => q['question'] == 'Tatlı kahveleri sever misiniz?')] == 'Evet';
    bool prefersCold = _answers[_questions.indexWhere((q) => q['question'] == 'Kahvenizi nasıl içmek istersiniz?')] == 'Soğuk';
    bool prefersFlavor = _answers[_questions.indexWhere((q) => q['question'] == 'Kahvenizde aromalı şuruplar ister misiniz?')] == 'Evet';
    String intensity = _answers[_questions.indexWhere((q) => q['question'] == 'Kahvenizin yoğunluğunu nasıl seversiniz?')];

    if (prefersFlavor && prefersCold && !prefersMilk) {
      return 'Soğuk Tatlı ve Sütsüz Kahveler';
    } else if (prefersFlavor && prefersCold) {
      return 'Soğuk Tatlı ve Aromalı Kahveler';
    } else if (prefersFlavor) {
      return 'Şuruplu Kahveler';
    } else if (prefersMilk && prefersCold && likesSweet) {
      return 'Tatlı Soğuk Sütlü Kahveler';
    } else if (prefersMilk && prefersCold) {
      return 'Soğuk Sütlü Kahveler';
    } else if (prefersMilk && intensity == 'Yoğun') {
      return 'Sert Sütlü Kahveler';
    } else if (prefersMilk) {
      return 'Sütlü Kahveler';
    } else if (prefersCold) {
      return 'Soğuk Kahveler';
    } else if (likesSweet) {
      return 'Tatlı ve Aromalı Kahveler';
    } else {
      switch (intensity) {
        case 'Hafif':
          return 'Espresso Tabanlı Kahveler';
        case 'Orta':
          return 'Sade Kahveler';
        case 'Yoğun':
        default:
          return 'Sade Kahveler';
      }
    }
  }

  void _resetQuestions() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers.clear();
    });
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Kahve Kaşifi Öneri'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/soru.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              width: 250, // Genişlik
              height: 280, // Yükseklik
              margin: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5), // Daha fazla saydam beyaz arka plan
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _questions[index]['question'],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_questions[index].containsKey('note'))
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  _questions[index]['note'],
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            const SizedBox(height: 4),
                            ...(_questions[index]['options'] as List<String>)
                                .map(
                                  (option) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.black, width: 1),
                                    minimumSize: Size(80, 30),
                                  ),
                                  onPressed: () =>
                                      _nextQuestion(option),
                                  child: Text(option,
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            )
                                .toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
