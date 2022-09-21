import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/tasks/task_controller.dart';
import 'package:agenda_app/src/widgets/no_task_widget.dart';

class TaskPage extends StatelessWidget {

  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: const Text('Mis Tareas'),
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder( borderRadius: BorderRadius.circular(30) ),
          null,
          0
        ),
      ),
      // body: NoTaskWidget( text: 'No hay tareas pendientes' ),
      body: _taskCard(context),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'openAddTaskPage',
        backgroundColor: Colors.indigo[300],
        elevation: 15,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
        icon: const Icon(Icons.add),
        label: const Text('Agregar tarea'),
        onPressed: () {
          _taskController.goToAddTaskPage();
        },
      ),

    );
  }

  Widget _taskCard(BuildContext context) {

    return GestureDetector(
      onTap: (){
        _taskController.openBottomSheet(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 20 ),
        child: Container(
          margin: const EdgeInsets.only( top: 10, bottom: 30 ),
          width: double.infinity,
          height: 100,
          decoration: _cardBorders(),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned(
                left: 15,
                top: 40,
                child: _taskText()
              ),
              Positioned(
                // left: 5,
                // top: 0,
                // bottom: 5,
                child: _taskChecked()
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _eventDate('08/12')
              ),
            ]
          )
        )
      )

    );

  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset( 0, 6 ),
        blurRadius: 10,
      )
    ]
  );

  Widget _taskText() {

    return SizedBox(
      width: 350,
      child: Container(
        margin: const EdgeInsets.only(right: 25),
        child: const Text(
          'Inteligencia Artificial', 
          maxLines: 3, 
          overflow: TextOverflow.ellipsis,
        )
      )
    );

  }

  Widget _taskChecked() {

    return Obx( () =>
      Checkbox(
        overlayColor: MaterialStateProperty.all(Colors.indigo),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        side: MaterialStateBorderSide.resolveWith(
          (states) => BorderSide(width: 2.0, color: Colors.orange.shade300),
        ),
        activeColor: Colors.orange[300],
        checkColor: Colors.indigo[700],
        value: _taskController.isSelected.value, 
        onChanged: (value) => _taskController.isSelected.value = !_taskController.isSelected.value
        
      ),
    );

  }

  Widget _eventDate(String fecha) {

    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(fecha, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ),
      ),
      width: 150,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.indigo[600],
        borderRadius: const BorderRadius.only( topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
      )
    );
  }

}