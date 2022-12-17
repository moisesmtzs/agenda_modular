import 'package:agenda_app/src/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends StatelessWidget {

  late Task task;
  late var datetime = DateFormat("yyyy-MM-dd").format(DateTime.parse(task.deliveryDate ?? '') );

  TaskDetailPage({ Key? key, required this.task}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.only(top: 20, bottom: 40, left: 30, right: 30),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Text(
            task.name ?? '', 
            style: const TextStyle( fontSize: 30, fontWeight: FontWeight.bold ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Text(
            task.description ?? '',
            style: const TextStyle( fontSize: 16 ),
          ),
          const SizedBox(height: 10),
          Text(
            'Fecha límite: $datetime',
            style: const TextStyle( fontSize: 16 ),
          ),
        ] 
      ),

    );
  }
}
