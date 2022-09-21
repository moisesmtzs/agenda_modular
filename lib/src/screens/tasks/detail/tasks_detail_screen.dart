import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.only(top: 20, bottom: 40, left: 30, right: 30),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: const [
          Text(
            'Realizar tarea de Química', 
            style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 
            style: TextStyle( fontSize: 16 ),
          ),
          SizedBox(height: 10),
          Text(
            'Fecha límite: 09/10/2022', 
            style: TextStyle( fontSize: 16 ),
          ),
        ] 
      ),

    );
  }
}
