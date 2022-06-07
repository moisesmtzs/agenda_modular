import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Agenda App',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Agenda App - Modular'),
          ),
          body: Center(
            child: Column(
              children: const [
                Icon(Icons.access_time_outlined),
                SizedBox(height: 35),
                Text("Hola guapo")

              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon( Icons.add )
          )
        ),
        theme: ThemeData.light().copyWith(
          // colorScheme: ColorScheme(secondary: Colors.deepPurple[200]),
            scaffoldBackgroundColor: Colors.grey[300],
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: Colors.grey[350],
                selectionHandleColor: Colors.deepPurple[400],
                cursorColor: Colors.deepPurple),
            appBarTheme: AppBarTheme(
              elevation: 0,
              color: Colors.indigo[300],
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.orange[300], elevation: 0)
          )
        );
  }
}
