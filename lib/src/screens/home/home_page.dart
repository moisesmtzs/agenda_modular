import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:agenda_app/src/screens/home/home_controller.dart';
import 'package:agenda_app/src/widgets/card_container.dart';
import 'package:agenda_app/src/widgets/custom_painters.dart';


class HomePage extends StatelessWidget {

  HomeController homeController = Get.put(HomeController());

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: _drawer(context),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => scaffoldKey.currentState?.openDrawer(), 
          icon: SvgPicture.asset("assets/icons/menu.svg")
        ),
        backgroundColor: Colors.transparent,
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
        children: <Widget> [
          drawCircles(context),
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _buttonAssistant(context),
            ] 
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
            const GButton(
              // active: true,
              // iconActiveColor: Colors.white,
              icon: Icons.home_outlined,
              text: 'Página Principal'
            ),
            const GButton(
              icon: Icons.search_rounded,
              text: 'Buscar'
            ),
            GButton(
              onPressed: () => homeController.goToUpdatePage(),
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
            offset: Offset(widthOfScreen * 0.04, heightOfScreen * 0.08),
            radius: widthOfScreen * 0.2,
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
                      // child: FadeInImage(
                      //   fit: BoxFit.cover,
                      //   fadeInDuration: const Duration(milliseconds: 50),
                      //   placeholder: const AssetImage('assets/img/no-image.png'),
                      //   image: homeController.userSession.image != null
                      //     ? NetworkImage(homeController.userSession.image!)
                      //     : const AssetImage('assets/img/user_profile_2.png') as ImageProvider,
                      // ),
                    ),
                  )
                  
                ),
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homeController.userSession.name ?? '', 
                      style: const TextStyle(
                        fontSize: 24.0, 
                        color: Colors.white, 
                        fontWeight: FontWeight.bold 
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, 
                    ),
                    // const SizedBox(height: 5),
                    Text(
                      homeController.userSession.email ?? '', 
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
            color: Colors.grey[200],
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
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.002, 
        horizontal: MediaQuery.of(context).size.width * 0.001
      ),
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.06),
      child: Column(
        children: [
          const CardContainer(
            child: Text(
              'Habla aquíHabla aquí aquíHabla aquíHabla aquíHabla aquí aquíHabla aquíHabla aquíHabla aquí aquíHabla aquíHabla aquíHabla aquí aquíHabla aquí', 
              style: TextStyle( fontSize: 20 )
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