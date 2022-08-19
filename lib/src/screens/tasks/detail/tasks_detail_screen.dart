import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      margin: const EdgeInsets.all(60),
      child: const Text('Aquí va el detalle de una tarea'),

    );
  }
}
