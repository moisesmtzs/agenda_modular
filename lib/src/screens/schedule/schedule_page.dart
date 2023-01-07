import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/schedule/schedule_controller.dart';

class SchedulePage extends StatelessWidget {
  ScheduleController subjectController = Get.put(ScheduleController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Horario',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar Materia'),
        onPressed: () => subjectController.goToSubject(),
        icon: const Icon(Icons.add_circle),
      ),
      body: Center(
        child: Table(
          children: [
            TableRow(//Dias
                children: [
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
            ]),
            TableRow(//Lunes
                children: [
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
            ]),
            TableRow(//Martes
                children: [
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
            ]),
            TableRow(//Mercoles
                children: [
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
            ]),
            TableRow(//Jueves
                children: [
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
            ]),
            TableRow(//Viernes
                children: [
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
            ]),
            TableRow(//Sabado
                children: [
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
              rectangulo(),
            ]),
          ],
        ),
      ),
    );
  }

  Widget rectangulo() {
    return Container(
      width: 70,
      height: 30,
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.indigo[100],
      ),
    );
  }
}
