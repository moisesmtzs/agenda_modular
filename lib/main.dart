import 'package:agenda_app/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_zoom_drawer/config.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/screens/screens.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});

void main() async {
  await GetStorage.init();
  Get.put<MyDrawerController>(MyDrawerController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  final drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda App',
      initialRoute: userSession.id != null ? '/home' : '/',
      navigatorKey: Get.key,
      defaultTransition: Transition.rightToLeft,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      getPages: [
        GetPage(
          name: '/',
          page: () => LoginPage(),
          transition: Transition.leftToRight
        ),
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
          transition: Transition.rightToLeft
        ),
        GetPage(
          name: '/home',
          page: () => HomePage(),
          transition: Transition.noTransition
        ),
        GetPage(
          name: '/menu',
          page: () => MenuPage(),
          transition: Transition.noTransition
        ),
        GetPage(
          name: '/updateProfile',
          page: () => UpdateProfilePage(),
          transition: Transition.noTransition
        ),
        GetPage(
          name: '/search',
          page: () => SearchPage(),
          transition: Transition.noTransition
        ),
        GetPage(
          name: '/task',
          page: () => TaskPage(),
        ),
        GetPage(
          name: '/addTask',
          page: () => AddTaskPage(),
          transition: Transition.noTransition
        ),
        GetPage(
          name: '/schedule',
          page: () => SchedulePage(),
        ),
        GetPage(
            name: '/registerSubject',
            page: () => RegisterSubjectPage(),
            transition: Transition.rightToLeft),
      ],
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        // appBarTheme: AppBarTheme(color: Colors.grey[200]),
        // scaffoldBackgroundColor: Colors.grey[200],
        // primaryColor: Colors.indigo[300],
        // splashColor: Colors.indigo[200],
        // dividerColor: Colors.white,
        // highlightColor: Colors.indigo.shade200.withOpacity(0.3),
        colorScheme: lightColorScheme,
        // colorScheme: ColorScheme(
        //   // backgroundColor: Colors.orange[300], elevation: 0
        //   primary: Colors.indigo.shade300,
        //   secondary: Colors.indigoAccent,
        //   background: Colors.grey.shade300,
        //   brightness: Brightness.light,
        //   error: Colors.grey.shade300,
        //   surface: Colors.grey.shade300,
        //   onBackground: Colors.grey.shade300,
        //   onError: Colors.grey.shade300,
        //   onPrimary: Colors.grey.shade300,
        //   onSecondary: Colors.grey.shade300,
        //   onSurface: Colors.grey.shade300,
        // ),
      )
    );
  }
}