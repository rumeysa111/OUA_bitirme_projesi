import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'coffee_recommendation_tab.dart';
import 'random_coffee_tab.dart';
import 'coffee_shops_map_tab.dart';
import 'profil_page.dart';
import 'question_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    CoffeeRecommendationTab(),
    RandomCoffeeTab(),
    CoffeeShopsMapTab(),
    ProfilePage(),  // Profil sayfası burada ekleniyor
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Kahve Kaşifi',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: _selectedIndex == 0
          ? Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/landing_page.jpeg'),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 500, 16, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Bugün\nNe İçmek\nİstersin?',
                    style: GoogleFonts.poppins(
                      fontSize: 45,
                      height: 1.3,
                      color: const Color(0xFFFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF196733),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      child: Text(
                        'Keşfetmeye Başla',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: const Color(0xFFFFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          : _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: 'Tavsiye',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shuffle),
            label: 'Rastgele',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Harita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilim',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
