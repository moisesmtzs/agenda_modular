import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/schedule/schedule_controller.dart';

class SchedulePage extends StatelessWidget {
  ScheduleController registerSubjectController = Get.put(ScheduleController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: const Text('Mi Horario'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => registerSubjectController.goToRegisterSubject(),
        backgroundColor: Colors.indigo[300],
        child: const Icon(Icons.add_circle),
      ),
    );
  }
}
