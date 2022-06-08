import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:agenda_app/src/screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda App',
      initialRoute: '/',
      getPages: [
        GetPage( name: '/', page: () => LoginPage() ),
        GetPage( name: '/register', page: () => RegisterPage() )
      ],
      navigatorKey: Get.key,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.indigo[300],
        colorScheme: ColorScheme(
          // backgroundColor: Colors.orange[300], elevation: 0
          primary: Colors.indigo.shade300,
          secondary: Colors.indigoAccent, 
          background: Colors.grey.shade300, 
          brightness: Brightness.light, 
          error: Colors.grey.shade300, 
          surface: Colors.grey.shade300,
          onBackground: Colors.grey.shade300, 
          onError: Colors.grey.shade300, 
          onPrimary: Colors.grey.shade300, 
          onSecondary: Colors.grey.shade300, 
          onSurface: Colors.grey.shade300, 
        ),
      )
    );
  }
}
