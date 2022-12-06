import 'package:agenda_app/src/models/task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/tasks/task_controller.dart';
import 'package:agenda_app/src/widgets/no_task_widget.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatelessWidget {

  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Obx( () => DefaultTabController(
        length: _taskController.status.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
            child: AppBar(
              toolbarHeight: 120,
              backgroundColor: Colors.indigo[300],
              title: const Text('Mis Tareas'),
              shape: ShapeBorder.lerp(
                RoundedRectangleBorder( borderRadius: BorderRadius.circular(30) ),
                null,
                0
              ),
              bottom: TabBar(
                indicatorColor: const Color.fromARGB(255, 159, 169, 230),
                labelColor: const Color.fromARGB(255, 159, 169, 230),
                unselectedLabelColor: Colors.grey[200],
                isScrollable: true,
                tabs: List<Widget>.generate(_taskController.status.length, (index){
                  return Tab(
                    child: Text(_taskController.status[index]),
                  );
                }),
              )
            ),
          ),
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: _taskController.status.map((String status) {
              return FutureBuilder(
                future: _taskController.getTasks(status),
                builder: (context, AsyncSnapshot<List<Task?>> snapshot) {
                  if (snapshot.hasData) {
                    if ( snapshot.data!.isNotEmpty ) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return _taskCard(snapshot.data![index], context);
                        }
                      );
                    } else {
                      return NoTaskWidget(text: 'No hay tareas agregadas');
                    }
                  } else {
                    return NoTaskWidget(text: 'No hay tareas agregadas');
                  }
                }
              );
            }).toList()
          ),
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
      
        ),
      ),
    );
  }

  Widget _taskCard(Task? task, BuildContext context) {

    late var datetime = DateFormat("yyyy-MM-dd").format(DateTime.parse(task?.deliveryDate ?? '') );

    return GestureDetector(
      onTap: (){
        _taskController.openBottomSheet(context, task!);
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
                child: _taskText(task?.name ?? '')
              ),
              Positioned(
                // left: 5,
                // top: 0,
                // bottom: 5,
                child: _taskChecked(task?.status ?? '')
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _eventDate(datetime)
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

  Widget _taskText(String taskName) {

    return SizedBox(
      width: 350,
      child: Container(
        margin: const EdgeInsets.only(right: 25),
        child: Text(
          (taskName != '') ? taskName : "Sin nombre a tarea asignado", 
          maxLines: 3, 
          overflow: TextOverflow.ellipsis,
        )
      )
    );

  }

  Widget _taskChecked(String status) {

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
        onChanged: (value) {
          _taskController.isSelected.value = !_taskController.isSelected.value;
        }
        
      ),
    );

  }

  Widget _eventDate(String fecha) {

    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            (fecha != '') ? fecha : "Sin fecha de entrega asignada", 
            style: const TextStyle(color: Colors.white, fontSize: 13)
          ),
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