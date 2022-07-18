import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:agenda_app/src/screens/home/home_controller.dart';
import 'package:agenda_app/src/widgets/card_container.dart';

import 'dart:ui';



class HomePage extends StatelessWidget {

  HomeController homeController = Get.put(HomeController());

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      // backgroundColor: Colors.indigo[300],
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: _drawer(context),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo[200],
        toolbarHeight: 65,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder( borderRadius: BorderRadius.circular(30) ),
          null,
          0
        ),
        leading: IconButton(
          onPressed: () => scaffoldKey.currentState?.openDrawer(), 
          icon: SvgPicture.asset("assets/icons/menu.svg")
        ),
        // backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black, size: 30.0),
        title: const Text(
          'Task Manager', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 22 ,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Stack(
        // physics: const BouncingScrollPhysics(),
        children: [
          _fondoapp(),
          _buttonAssistant(context),
        ]
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only( left: 15, right: 15, bottom: 20, top: 10 ),
        child: GNav(
          backgroundColor: Colors.transparent,
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
            const GButton(
              active: true,
              // iconActiveColor: Colors.white,
              icon: Icons.home_outlined,
              text: 'Página Principal'
            ),
            GButton(
              onPressed: () => homeController.goToSearchPage(),
              icon: Icons.search_rounded,
              text: 'Buscar',
              // iconColor: Colors.white
            ),
            GButton(
              onPressed: () => homeController.goToUpdatePage(),
              icon: Icons.person_outline_rounded,
              text: 'Perfil',
            ),
          ]
        ),
      ),
    );
  }

    Widget _fondoapp(){

    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
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
          gradient: LinearGradient(
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

  Widget _drawer(BuildContext context) {

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 25,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: ListView(
              // mainAxisSize: MainAxisSize.max,
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  height: 60,
                  margin: const EdgeInsets.only(top: 10),
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: ClipOval(
                      child: GetBuilder<HomeController>(
                        builder: (value) => FadeInImage(
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 50),
                          placeholder: const AssetImage('assets/img/no-image.png'),
                          image: homeController.userSession.image != null
                            ? NetworkImage(homeController.userSession.image!)
                            : const AssetImage('assets/img/user_profile_2.png') as ImageProvider,
                        )
                      )
                    ),
                  )
                  
                ),
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homeController.userSession.name ?? 'Moises', 
                      style: TextStyle(
                        fontSize: 24.0, 
                        color: Colors.indigo[300], 
                        fontWeight: FontWeight.bold 
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, 
                    ),
                    // const SizedBox(height: 5),
                    Text(
                      homeController.userSession.email ?? 'Correo', 
                      style: TextStyle(
                        fontSize: 14.0, 
                        color: Colors.indigo[200], 
                        fontWeight: FontWeight.bold 
                      ),
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis, 
                    ),
                  ],
                ),
              ],
            )
          ),
          Divider( 
            thickness: 1.4,
            indent: MediaQuery.of(context).size.width * 0.06,
            endIndent: MediaQuery.of(context).size.width * 0.06,
            color: Colors.indigo[300],
          ),
          const SizedBox(height:15),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: () => homeController.goToTaskPage(),
            title: Text('Mis Tareas', style: TextStyle( color: Colors.indigo[300], fontSize: 20 )),
            trailing: Icon(Icons.task, color: Colors.indigo[300], size: 27)
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: () => homeController.goToSchedulePage(),
            title: Text('Mi Horario', style: TextStyle( color: Colors.indigo[300], fontSize: 20 )),
            trailing: Icon(Icons.schedule_rounded, color: Colors.indigo[300], size: 27)
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: () => homeController.confirmationDialog(context),
            title: Text('Cerrar Sesión', style: TextStyle( color: Colors.indigo[300], fontSize: 20 )),
            trailing: Icon(Icons.logout_rounded, color: Colors.indigo[300], size: 27)
          ),
        ]
      ),
    );

  }

  Widget _buttonAssistant(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(
        // vertical: MediaQuery.of(context).size.height * 0.0009, 
        horizontal: MediaQuery.of(context).size.width * 0.001
      ),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      child: Column(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur( sigmaX: 8.0, sigmaY: 8.0 ),
            child: const CardContainer(
              child: Text(
                'Habla aquí Habla aquí Habla aquí Habla aquí Habla aquí', 
                style: TextStyle( fontSize: 20 )
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.36
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.023
                )),
                fixedSize: MaterialStateProperty.all<Size>(Size.fromWidth(MediaQuery.of(context).size.width *  0.37 ), ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
              ),
              // isExtended: true,
              onPressed: () {}, 
              child: Icon(Icons.keyboard_voice_sharp, size: MediaQuery.of(context).size.height * 0.04,),
            ),
          ),
        ],
      ),
    );

  }

}