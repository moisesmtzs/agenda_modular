import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/home/home_controller.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatelessWidget {

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(context),
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black, size: 30.0),
        title: const Text('Task Manager', style: TextStyle( color: Colors.black, fontSize: 22 ),),
      ),
      body: Center(
        child: _buttonAssistant(context),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only( left: 15, right: 15, bottom: 20, top: 10 ),
        child: GNav(
          selectedIndex: 0,
          padding: const EdgeInsets.all(15),
          tabBorderRadius: 18,
          color: Colors.black,
          tabBackgroundColor: Colors.orange.shade100,
          activeColor: Colors.orange[300],
          gap: 8,
          onTabChange: (index) {
            if ( index == 2 ) {
              homeController.goToUpdatePage();
            }
          },
          tabs: const [
            GButton(
              active: true,
              // iconActiveColor: Colors.white,
              icon: Icons.home_outlined,
              text: 'Página Principal'
            ),
            GButton(
              icon: Icons.search_rounded,
              text: 'Buscar'
            ),
            GButton(
              // onPressed: () => homeController.goToUpdatePage(),
              icon: Icons.person_outline_rounded,
              text: 'Perfil'
            ),
          ]
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) {

    return Drawer(
      backgroundColor: const Color(0xFF7986CB),
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
                  child: CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: Colors.orange[300],
                  )
                  
                ),
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Moises', 
                      style: TextStyle(
                        fontSize: 24.0, 
                        color: Colors.white, 
                        fontWeight: FontWeight.bold 
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, 
                    ),
                    // const SizedBox(height: 5),
                    Text(
                      'Correo', 
                      style: TextStyle(
                        fontSize: 14.0, 
                        color: Colors.grey[200], 
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
            indent: MediaQuery.of(context).size.width * 0.06, 
            endIndent: MediaQuery.of(context).size.width * 0.06, 
            color: Colors.grey[200] 
          ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          ListTile(
            onTap: () {},
            title: const Text('Mis Tareas', style: TextStyle( color: Colors.white )),
            trailing: const Icon(Icons.task, color: Colors.white)
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.008),
          ListTile(
            onTap: () {},
            title: const Text('Mi Horario', style: TextStyle( color: Colors.white )),
            trailing: const Icon(Icons.schedule_rounded, color: Colors.white)
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.008),
          ListTile(
            onTap: () => homeController.logOut(),
            title: const Text('Cerrar Sesión', style: TextStyle( color: Colors.white )),
            trailing: const Icon(Icons.logout_rounded, color: Colors.white)
          ),
        ]
      ),
    );

  }

  Widget _buttonAssistant(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric( vertical: 15, horizontal: 20 ),
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 15)),
              fixedSize: MaterialStateProperty.all<Size>(Size.fromWidth(MediaQuery.of(context).size.width *  0.34 ), ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo.shade300),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
            ),
            // isExtended: true,
            onPressed: () {}, 
            child: const Icon(Icons.keyboard_voice_sharp, size: 30,),
          ),
          const SizedBox(height: 25,),
          const Text('Habla aquí', style: TextStyle( fontSize: 20 ))
        ],
      ),
    );

  }

}