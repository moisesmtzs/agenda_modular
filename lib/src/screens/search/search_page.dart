import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SearchPage extends StatelessWidget {

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _fondoapp(),
          _search(context),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur( sigmaX: 8.0, sigmaY: 8.0 ),
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(62, 66, 107, 0.6),
              borderRadius: BorderRadius.circular(16.0)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric( horizontal: 15, vertical: 10 ),
              child: GNav(
                selectedIndex: _selectedIndex,
                padding: const EdgeInsets.all(15),
                tabBorderRadius: 18,
                color: Colors.white,
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
          ),
        ),
      ),
    );

  }

  Widget _fondoapp(){

    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.5),
          end: FractionalOffset(0.0, 1.0),
          colors: [
            Color.fromRGBO(52, 54, 101, 1.0),
            Color.fromRGBO(35, 37, 57, 1.0),
            // Colors.purple[900],
            // Colors.purple[800]
          ]
        ),
      ),
    );

    final cajaRosa = Transform.rotate(
      angle: -pi / 5.0, 
      child: Container(
        height: 280.0,
        width: 280.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(72.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(159, 168, 218, 1),
              Color.fromRGBO(106, 119, 193, 1),
            ]
          )
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        gradiente,
        Positioned(
          top: 400.0,
          right: -50.0,
          child: cajaRosa
        )
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