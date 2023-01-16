import 'dart:math';
import 'dart:ui';

import 'package:agenda_app/src/ia/ia_controller.dart';
import 'package:agenda_app/src/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:agenda_app/src/screens/home/home_controller.dart';

//IA//
import 'package:agenda_app/src/ia/text_to_speech.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

// import 'package:agenda_app/src/widgets/card_container.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  IA_Controller _ia = IA_Controller();

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    MyDrawerController _zoomController = MyDrawerController();
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo[200],
        toolbarHeight: 65,
        shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            null,
            0),
        leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: SvgPicture.asset("assets/icons/menu.svg")),
        // automaticallyImplyLeading: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black, size: 30.0),
        title: const Text(
          'Task Manager',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(children: [
        _fondoapp(),
        SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: _buttonAssistant(context)),
      ]),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(62, 66, 107, 0.6),
                borderRadius: BorderRadius.circular(16.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                    const GButton(
                        // active: true,
                        // iconActiveColor: Colors.white,
                        icon: Icons.home_outlined,
                        text: 'Página Principal'),
                    GButton(
                      onPressed: () =>
                          Get.offNamedUntil('/search', (route) => false),
                      icon: Icons.search_rounded,
                      text: 'Buscar',
                      // iconColor: Colors.white
                    ),
                    GButton(
                      onPressed: () =>
                          Get.offNamedUntil('/updateProfile', (route) => false),
                      icon: Icons.person_outline_rounded,
                      text: 'Perfil',
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fondoapp() {
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
            ]),
      ),
    );

    final purpleSquare = Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 280.0,
        width: 280.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(72.0),
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(159, 168, 218, 1),
              Color.fromRGBO(106, 119, 193, 1),
            ])),
      ),
    );

    return Stack(
      children: <Widget>[
        gradiente,
        Positioned(top: 400.0, right: -50.0, child: purpleSquare)
      ],
    );
  }

  Widget _buttonAssistant(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          // vertical: MediaQuery.of(context).size.height * 0.0009,
          horizontal: MediaQuery.of(context).size.width * 0.001),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.13),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.36),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          vertical:
                              MediaQuery.of(context).size.height * 0.023)),
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size.fromWidth(MediaQuery.of(context).size.width * 0.37),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              // isExtended: true,
              onPressed: () => _listen(),

              child: Icon(_ia.getListening() ? Icons.mic : Icons.mic_none),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(62, 66, 107, 0.8),
                    borderRadius: BorderRadius.circular(16.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(8),
                    ),
                    child: Text(
                      _ia.getsText(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        ],
      ),
    );
  }

  //METODO QUE ESCUCHA LA VOZ//
  void _listen() async {
    if (!_ia.getListening()) {
      bool available = await _ia.getSpeech().initialize(
            onStatus: (val) => print('onStatus: $val'),
            onError: (val) => print('onError: $val'),
          );

      if (available) {
        setState(() => _ia.setListening(true));
        _ia.getSpeech().listen(
              onResult: (val) => setState(() {
                _ia.setsText(val.recognizedWords);

                if (val.hasConfidenceRating && val.confidence > 0) {
                  _ia.setConfidence(val.confidence);
                }
              }),
            );
      }
    } else {
      setState(() => _ia.setListening(false));
      if (_ia.getListening() == false) {
        _ia.speakRosalind(_ia.getsText());
      }
      _ia.stopListening();
    }
  }
}

class HomePage extends GetView<MyDrawerController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        style: DrawerStyle.defaultStyle,
        menuScreen: MenuPage(),
        mainScreen: MyHomePage(),
        borderRadius: 30.0,
        showShadow: true,
        angle: 0.0,
        menuBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        drawerShadowsBackgroundColor: Colors.grey,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
      ),
    );
  }
}

class MenuPage extends GetView<MyDrawerController> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: ListView(
                  // mainAxisSize: MainAxisSize.max,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        height: 60,
                        margin: const EdgeInsets.only(top: 10),
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ClipOval(
                              child: GetBuilder<HomeController>(
                                  builder: (value) => FadeInImage(
                                        fit: BoxFit.cover,
                                        fadeInDuration:
                                            const Duration(milliseconds: 50),
                                        placeholder: const AssetImage(
                                            'assets/img/no-image.png'),
                                        image: homeController
                                                    .userSession.image !=
                                                null
                                            ? NetworkImage(homeController
                                                .userSession.image!)
                                            : const AssetImage(
                                                    'assets/img/user_profile_2.png')
                                                as ImageProvider,
                                      ))),
                        )),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeController.userSession.name ?? 'Moises',
                          style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.indigo[300],
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // const SizedBox(height: 5),
                        Text(
                          homeController.userSession.email ?? 'Correo',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.indigo[200],
                              fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                )),
            Divider(
              thickness: 1.4,
              indent: MediaQuery.of(context).size.width * 0.06,
              endIndent: MediaQuery.of(context).size.width * 0.06,
              color: Colors.indigo[300],
            ),
            const SizedBox(height: 25),
            ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: () => homeController.goToTaskPage(),
                title: Text('Mis Tareas',
                    style: TextStyle(color: Colors.indigo[300], fontSize: 16)),
                trailing:
                    Icon(Icons.task, color: Colors.indigo[300], size: 27)),
            const SizedBox(height: 15),
            ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: () => homeController.goToSchedulePage(),
                title: Text('Mi Horario',
                    style: TextStyle(color: Colors.indigo[300], fontSize: 16)),
                trailing: Icon(Icons.schedule_rounded,
                    color: Colors.indigo[300], size: 27)),
            const SizedBox(height: 15),
            ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: () => homeController.goToSubject(),
                title: Text('Materias',
                    style: TextStyle(color: Colors.indigo[300], fontSize: 16)),
                trailing:
                    Icon(Icons.backpack, color: Colors.indigo[300], size: 27)),
            const SizedBox(height: 15),
            ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: () => homeController.confirmationDialog(context),
                title: Text('Cerrar Sesión',
                    style: TextStyle(color: Colors.indigo[300], fontSize: 16)),
                trailing: Icon(Icons.logout_rounded,
                    color: Colors.indigo[300], size: 27)),
          ]),
    );
  }
}

class MyDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    print("Toggle drawer");
    zoomDrawerController.toggle?.call();
    update();
  }
}
