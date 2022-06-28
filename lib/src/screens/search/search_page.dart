import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:agenda_app/src/widgets/custom_painters.dart';

class SearchPage extends StatelessWidget {

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          drawCircles(context),
          _search(context)
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only( left: 15, right: 15, bottom: 20, top: 10 ),
        child: GNav(
          selectedIndex: _selectedIndex,
          padding: const EdgeInsets.all(15),
          tabBorderRadius: 18,
          color: Colors.black,
          tabBackgroundColor: Colors.indigo.shade100,
          activeColor: Colors.indigo[300],
          gap: 8,
          onTabChange: (index) {
            _selectedIndex = index;
          },
          tabs: [
            GButton(
              onPressed: () {
                Get.offNamedUntil('/home', (route) => false);
              },
              // iconActiveColor: Colors.white,
              icon: Icons.home_outlined,
              text: 'Página Principal'
            ),
            const GButton(
              icon: Icons.search_rounded,
              text: 'Buscar'
            ),
            GButton(
              // active: true,
              onPressed: () {
                Get.offNamedUntil('/updateProfile', (route) => false);
              },
              icon: Icons.person_outline_rounded,
              text: 'Perfil'
            ),
          ]
        ),
      ),
    );


  }

  Widget drawCircles(BuildContext context) {

    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        CustomPaint(
          painter: DrawCircle(
            offset: Offset(widthOfScreen * 0.0005, heightOfScreen * 0.08),
            radius: widthOfScreen * 0.16,
            color: Colors.indigo.shade300,
            hasShadow: true,
            shadowColor: Colors.indigo[200],
          ),
        ),
        CustomPaint(
          painter: DrawCircle(
            offset: Offset(widthOfScreen * 0.75, heightOfScreen * 0.05),
            radius: widthOfScreen * 0.5,
            color: Colors.indigo.shade300,
            hasShadow: true,
            shadowColor: Colors.indigo[200],
          ),
        ),
        CustomPaint(
          painter: DrawCircle(
            offset: Offset(widthOfScreen * 0.1, heightOfScreen * 0.95),
            radius: widthOfScreen * 0.175,
            color: Colors.indigo.shade300,
            hasShadow: true,
            shadowColor: Colors.indigo[200],
          ),
        ),
        CustomPaint(
          painter: DrawCircle(
            offset: Offset(widthOfScreen * 0.35, heightOfScreen * 0.85),
            radius: widthOfScreen * 0.1,
            color: Colors.indigo.shade300,
            hasShadow: true,
            shadowColor: Colors.indigo[200],
          ),
        ),
      ],
    );
  }
  
  Widget _search(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.09, horizontal: 20),
      child: SizedBox(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (String name) {
              String name = '';
            }, 
            autofocus: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(188, 197, 202, 233),
              hintText: 'Buscar',
              suffixIcon: const Icon(Icons.search_rounded, color: Colors.white),
              hintStyle: const TextStyle( fontSize: 17, color: Colors.white ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1.7,
                  color: Colors.white24
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 2.0,
                  color: Colors.white
                )
              ),
              contentPadding: const EdgeInsets.all(12)
            )
          ),
        ),
      ),
    );
  }

}