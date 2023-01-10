import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/subject/subject_controller.dart';

class SubjectPage extends StatelessWidget {
  final SubjectController _subjectController = Get.put(SubjectController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Materias',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar Materia'),
        onPressed: () => _subjectController.goToAddSubject(),
        icon: const Icon(Icons.add_circle),
      ),
      body: Center(),
    );
  }
}
