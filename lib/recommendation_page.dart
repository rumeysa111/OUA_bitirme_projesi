import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:coffe2/home_page.dart';  // HomePage'inizin bulunduğu yolu buraya ekleyin

class RecommendationPage extends StatelessWidget {
  final String coffee;
  final VoidCallback resetCallback;
  final List<String> answers;

  const RecommendationPage({
    super.key,
    required this.coffee,
    required this.resetCallback,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Kahve Öneri'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/coff6.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,  // Arka planı düz beyaz yapıyoruz
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Sizin için önerilen kahve \n$coffee',
                  style: const TextStyle(fontSize: 28.0, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveCoffeeSelection(coffee, answers, context);
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
                child: const Text(
                  'Bu Kahveyi Seç',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: resetCallback,
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
                child: const Text(
                  'Yeniden Başla',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCoffeeSelection(String coffee, List<String> answers, BuildContext context) {
    FirebaseFirestore.instance.collection('coffee_selections').add({
      'coffee': coffee,
      'answers': answers,
      'timestamp': Timestamp.now(),
    }).then((docRef) {
      print('Kahve seçimi kaydedildi: $docRef');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }).catchError((error) {
      print('Kahve seçimi kaydedilemedi: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kahve seçimi kaydedilemedi: $error')),
      );
    });
  }
}
