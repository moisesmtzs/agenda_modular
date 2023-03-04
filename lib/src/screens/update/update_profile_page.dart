// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, unnecessary_new, avoid_print, unused_import, non_constant_identifier_names
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import 'package:agenda_app/src/screens/navigation_controller.dart';
import 'package:agenda_app/src/screens/update/update_profile_controller.dart';
import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:agenda_app/src/ui/input_decoration.dart';
import 'package:agenda_app/src/widgets/card_container.dart';

class UpdateProfilePage extends StatelessWidget {

  NavigationController navigationController = Get.find();
  UpdateProfileController updatePageController = Get.put(UpdateProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          _fondoapp(),
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                  Container(
                    child: CardContainer(
                      child: Column(
                        children: [
                          Text( 'Editar Perfil', style: Theme.of(context).textTheme.headline4 ),
                          _headerIcon(context),
                          _updateForm(context)
                        ],
                      )
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ],
              )
            
          ),
        ]
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur( sigmaX: 6.0, sigmaY: 6.0 ),
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(62, 66, 107, 0.6),
              borderRadius: BorderRadius.circular(16.0)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric( horizontal: 15, vertical: 10 ),
              child: Obx( () => GNav(
                selectedIndex: navigationController.selectedIndex.value,
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric( horizontal: 25, vertical: 15),
                tabBorderRadius: 18,
                color: Colors.white,
                tabBackgroundColor: Colors.indigo.shade100,
                activeColor: Colors.indigo[300],
                gap: 10,
                duration: const Duration( milliseconds: 1500 ),
                onTabChange: (index) {
                  navigationController.changeIndex(index);
                },
                tabs: [
                  GButton(
                    onPressed: () => updatePageController.goToHomePage(),
                    icon: Icons.home_outlined,
                    text: 'Página Principal',
                    shadow: [
                      BoxShadow(
                        color: AppColors.colors.primary.withOpacity(0.4),
                      )
                    ],
                  ),
                  GButton(
                    icon: Icons.person_outline_rounded,
                    text: 'Perfil'
                  ),
                ]
              ),
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
                decoration: const InputDecoration(
                  hintText: "Will",
                  labelText: "Nombre",
                  prefixIcon: Icon(Icons.perm_identity_sharp)
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
                decoration: const InputDecoration(
                  hintText: "Smith",
                  labelText: "Apellido",
                  prefixIcon: Icon(Icons.co_present_outlined)
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
                decoration: const InputDecoration(
                  hintText: "5555555555",
                  labelText: "Número de teléfono",
                  prefixIcon: Icon(Icons.call)
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
                color: AppColors.colors.primary,
                child: Container(
                  padding: EdgeInsets.symmetric( horizontal: 30, vertical: 15 ),
                  child: updatePageController.isLoading.value
                    ? FittedBox(child: Text('Espere...', style: TextStyle( color: Colors.white )))
                        // SizedBox(width: MediaQuery.of(context).size.width * 0.006),
                        // SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color:  Colors.orange[300]))
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
                color: AppColors.colors.tertiary,
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