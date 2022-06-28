// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, unnecessary_new, avoid_print, unused_import, non_constant_identifier_names
import 'dart:convert';
import 'package:agenda_app/src/widgets/custom_painters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import 'package:agenda_app/src/screens/update/update_profile_controller.dart';
import 'package:agenda_app/src/ui/input_decoration.dart';
import 'package:agenda_app/src/widgets/card_container.dart';

class UpdateProfilePage extends StatelessWidget {

  UpdateProfileController updatePageController = Get.put(UpdateProfileController());

  int _selectedIndex = 2;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          drawCircles(context),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  // _purpleBox(context),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.006),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                  CardContainer(
                    child: Column(
                      children: [
                        Text( 'Editar Perfil', style: Theme.of(context).textTheme.headline4 ),
                        // SizedBox( height: 10 ),
                        _headerIcon(context),
                        // SizedBox( height: 20 ),
                        _updateForm(context)
                      ],
                    )
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ],
              )
            
          ),
        ]
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
              onPressed: () => updatePageController.goToHomePage(),
              // iconActiveColor: Colors.white,
              icon: Icons.home_outlined,
              text: 'Página Principal'
            ),
            GButton(
              icon: Icons.search_rounded,
              text: 'Buscar',
              onPressed: () => updatePageController.goToSearchPage(),
            ),
            GButton(
              // active: true,
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

  Widget _headerIcon(BuildContext context) {
  
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.12,
        child: GestureDetector(
          onTap: () => updatePageController.showAlertDialog(context),
          child: GetBuilder<UpdateProfileController> (
            builder: (value) => CircleAvatar(
              backgroundImage: updatePageController.imageFile != null
                ? FileImage(updatePageController.imageFile!)
                : updatePageController.userSession.image != null
                  ? NetworkImage(updatePageController.userSession.image!)
                  : AssetImage('assets/img/user_profile_2.png') as ImageProvider,
              radius: 50,
              backgroundColor: Colors.indigo[100],
            ),
          )
        ),
      ),
    );
    
  }

  Widget _updateForm(BuildContext context) {

    return Obx( () =>
      Container(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
    
          child: Column(
            children: [
              TextFormField(
                controller: updatePageController.nameController,
                cursorRadius: Radius.circular(8.0),
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                  hintText: "Will",
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
              TextFormField(
                controller: updatePageController.lastNameController,
                cursorRadius: const Radius.circular(8.0),
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                  hintText: "Smith",
                  labelText: "Apellido",
                  prefixIcon: Icons.co_present_outlined
                ),
                validator: ( value ){
                  String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                  RegExp nameregExp  = RegExp(pattern);
                  return nameregExp.hasMatch( value ?? '' ) 
                    ? null 
                    : 'Apellido no válido';
                }
              ),
              TextFormField(
                controller: updatePageController.phoneController,
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
              SizedBox( height: 25 ),
              MaterialButton(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10) ),
                disabledColor: Colors.grey,
                color: Colors.indigo[300],
                child: Container(
                  padding: EdgeInsets.symmetric( horizontal: 30, vertical: 15 ),
                  child: updatePageController.isLoading.value
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(child: Text('Espere...', style: TextStyle( color: Colors.white ),)),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.006),
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color:  Colors.orange[300]))
                      ],
                    )
                    : FittedBox(child: Text('Guardar cambios', style: TextStyle( color: Colors.white )))
                ),
                onPressed: updatePageController.isEnable.value 
                  ? () {
                    updatePageController.updateProfile(context);
                    updatePageController.isLoading.value = true;
                    Future.delayed(const Duration( milliseconds: 1500 ), (){
                      updatePageController.isLoading.value = false;
                    });
                  } 
                  : null
              ),
              SizedBox( height: 25 ),
              MaterialButton(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10) ),
                disabledColor: Colors.grey,
                color: Colors.red[300],
                splashColor: Colors.red,
                child: Container(
                  padding: EdgeInsets.symmetric( horizontal: 20, vertical: 15 ),
                  child: FittedBox(child: Text('Eliminar cuenta', style: TextStyle( color: Colors.white )))
                ),
                onPressed: updatePageController.isEnable2.value 
                  ? () {
                    updatePageController.confirmationDialog(context);
                  } 
                  : null
                
              ),
            ],
          )
        )
      ),
    );

  }

}