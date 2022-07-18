import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SearchPage extends StatelessWidget {

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo[300],
      body: _search(context),
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