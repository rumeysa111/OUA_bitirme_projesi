import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe2/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profilim'),
        backgroundColor: Colors.black12, // Kahverengi tonlarında AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('coffee_selections').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Henüz kahve seçimi yapılmadı.'));
          }

          // Kahve seçimlerini listelemeden önce filtreleme
          var coffeeSelections = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'coffee': data['coffee'],
              'rating': data['rating'] ?? 0.0,
            };
          }).toList();

          // Aynı kahve adını birden fazla listelememek için filtreleme
          var uniqueSelections = <String, Map<String, dynamic>>{};
          for (var selection in coffeeSelections) {
            uniqueSelections[selection['coffee']] = selection;
          }

          var filteredSelections = uniqueSelections.values.toList();

          return Column(
            children: [
              // Kullanıcı bilgilerini ve avatarı gösterecek kısım
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('Kullanıcı bilgileri bulunamadı.'));
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/user.png'),
                          backgroundColor: Colors.grey[200],
                        ),
                        SizedBox(width: 16),
                        Text(
                          '${userData['first_name'] ?? 'Ad'} ${userData['last_name'] ?? 'Soyad'}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'En son değerlendirilen kahveler',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                    ),
                    ...filteredSelections.map((selection) {
                      return Card(
                        color: Colors.brown[50], // Açık kahverengi tonlarında kart rengi
                        elevation: 3, // Kart yüksekliğini küçültme
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Marjinleri küçültme
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8), // Padding ekleme
                          title: Text(
                            selection['coffee'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Font boyutunu küçültme
                          ),
                          subtitle: RatingBar.builder(
                            initialRating: selection['rating'],
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0), // Item padding küçültme
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              _updateRating(selection['id'], rating);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateRating(String id, double rating) {
    FirebaseFirestore.instance.collection('coffee_selections').doc(id).update({
      'rating': rating,
    }).then((_) {
      print('Değerlendirme güncellendi: $rating');
    }).catchError((error) {
      print('Değerlendirme güncellenemedi: $error');
    });
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
     Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=>LoginScreen())); // veya uygun olan rota
    } catch (e) {
      print('Çıkış yapma hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çıkış yaparken bir hata oluştu.')),
      );
    }
  }
}
