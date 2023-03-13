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
        label: const Text('Agregar Clase'),
        onPressed: () => subjectController.goToClase(),
        icon: const Icon(Icons.add_circle),
      ),
      body: Center(
        child: Table(children: []),
      ),
    );
  }
}
