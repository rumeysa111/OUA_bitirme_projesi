import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'question_page.dart';
import 'main.dart';
import 'home_page.dart';
class CoffeeRecommendationTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionPage()),
            );
          },
          child: Text('Kahve Tavsiyesi Al',style: GoogleFonts.poppins(),),

        ),
      ],
    );
  }
}
