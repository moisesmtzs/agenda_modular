import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/clase/clase_controller.dart';

class ClasePage extends StatelessWidget {
  ClaseController claseController = Get.put(ClaseController());
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
        onPressed: () => claseController.goToSubject(),
        icon: const Icon(Icons.add_circle),
      ),
      body: Center(),
    );
  }
}
