// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, unnecessary_new, avoid_print, unused_import, non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import 'package:agenda_app/src/screens/update/update_profile_controller.dart';
import 'package:agenda_app/src/ui/input_decoration.dart';
import 'package:agenda_app/src/widgets/card_container.dart';

class UpdateProfilePage extends StatefulWidget {

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {

  UpdateProfileController updatePageController = Get.put(UpdateProfileController());
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0,
      //   backgroundColor: Color.fromRGBO(63, 63, 156, 0),
      //   child: Icon(Icons.arrow_back_ios_new_rounded),
      //   onPressed: (){
      //     Navigator.pop(context);
      //   }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                _purpleBox(),
                SizedBox(height: 10),
                CardContainer(
                  child: Column(
                    children: [
                      SizedBox( height: 10 ),
                      Text( 'Editar Perfil', style: Theme.of(context).textTheme.headline4 ),
                      SizedBox( height: 30 ),
                      _updateForm(context)
                    ],
                  )
                ),
                SizedBox( height: 25 ),
              ],
            )
          
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only( left: 15, right: 15, bottom: 20, top: 10 ),
        child: GNav(
          selectedIndex: 2,
          padding: const EdgeInsets.all(15),
          tabBorderRadius: 18,
          color: Colors.black,
          tabBackgroundColor: Colors.orange.shade100,
          activeColor: Colors.orange[300],
          gap: 8,
          onTabChange: (index) {
            if ( index == 0 ) {
              updatePageController.goToHomePage();
            }
          },
          tabs: const [
            GButton(
              // onPressed: () => updatePageController.goToHomePage(),
              // iconActiveColor: Colors.white,
              icon: Icons.home_outlined,
              text: 'Página Principal'
            ),
            GButton(
              icon: Icons.search_rounded,
              text: 'Buscar'
            ),
            GButton(
              active: true,
              icon: Icons.person_outline_rounded,
              text: 'Perfil'
            ),
          ]
        ),
      ),
    );
  }
  Widget _headerIcon() {
  
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: GestureDetector(
        onTap: () {},
        child: CircleAvatar(),
        
      ),
    );
    
  }

  Widget _purpleBox() {
      
    final size = MediaQuery.of(context).size;
    
    return Container(
      width: double.infinity,
      height: size.height * 0.28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // ignore: prefer_const_literals_to_create_immutables
          colors: [
            Color.fromARGB(255, 40, 71, 221),
            Color.fromARGB(255, 121, 102, 206),
          ]
        )
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(child: _Bubble(), top: 90, left: 30),
          Positioned(child: _Bubble(), top: -40, left: -30),
          Positioned(child: _Bubble(), top: -50, right: 10),
          Positioned(child: _Bubble(), bottom: -50, left: 10),
          Positioned(child: _Bubble(), bottom: 75, right: 20),
          _headerIcon(),
        ]
      ),
    );
    
  }

  Widget _Bubble(){

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      )    
    );
    
  }

  Widget _updateForm(BuildContext context) {

    return Container(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            TextFormField(
              // controller: _con.nameController,
              cursorRadius: Radius.circular(8.0),
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                hintText: "Will Smith",
                labelText: "Nombre",
                prefixIcon: Icons.perm_identity_sharp
              ),
              validator: ( value ){
                String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                RegExp nameregExp  = RegExp(pattern);
                return nameregExp.hasMatch( value ?? '' ) 
                  ? null 
                  : 'Nombre no válido';
              }
            ),
            SizedBox( height: 16 ),
            TextFormField(
              // controller: _con.phoneController,
              cursorRadius: Radius.circular(8.0),
              autocorrect: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecorations.authInputDecoration(
                hintText: "5555555555",
                labelText: "Número de teléfono",
                prefixIcon: Icons.call
              ),
              validator: ( value ){
                return ( value != null && value.length == 10 ) 
                  ? null
                  : 'Número no válido, deben ser 10 dígitos';
              }
            ),
            SizedBox( height: 16, ),
            TextFormField(
              // controller: _con.addressController,
              cursorRadius: Radius.circular(8.0),
              autocorrect: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: "St Petris",
                labelText: "Dirección de domicilio",
                prefixIcon: Icons.place_sharp
              ),
              validator: ( value ){
                return ( value != null && value.length >= 10 ) 
                  ? null
                  : 'Dirección no válida';
              }
            ),
            SizedBox( height: 25 ),
            MaterialButton(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10) ),
              disabledColor: Colors.grey,
              color: Colors.indigo[300],
              child: Container(
                padding: EdgeInsets.symmetric( horizontal: 30, vertical: 15 ),
                child: Text('Guardar cambios', style: TextStyle( color: Colors.white ))
              ),
              onPressed: () {},
            ),
            SizedBox( height: 25 ),
            MaterialButton(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10) ),
              disabledColor: Colors.grey,
              color: Colors.red[300],
              child: Container(
                padding: EdgeInsets.symmetric( horizontal: 20, vertical: 15 ),
                child: Text('Eliminar cuenta', style: TextStyle( color: Colors.white ))
              ),
              onPressed: () {},
            ),
          ],
        )
      )
    );

  }

  void refresh() {
    setState(() {

    });
  }

}