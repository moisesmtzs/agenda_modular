import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/screens/tasks/update/task_update_page.dart';
import 'package:agenda_app/src/screens/tasks/task_controller.dart';
import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:agenda_app/src/widgets/no_task_widget.dart';

class TaskPage extends StatefulWidget {
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  
  TaskController taskController = Get.put(TaskController());

  List<Future<List<Task?>>> tasks = [];

  @override
  void initState() {
    super.initState();
    taskController.init(refresh);
    
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      tasks = taskController.status.map((e) => taskController.getTasks(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: taskController.status.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
          child: Obx( () => AppBar(
            // actions: [
            //   IconButton(
            //     onPressed:() => _refresh(),
            //     icon: const Icon(Icons.refresh)
            //   )
            // ],
            toolbarHeight: 120,
            title: const Text('Mis Tareas', style: TextStyle(fontSize: 24)),
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              null,
              0
            ),
            bottom: TabBar(
              indicatorColor: AppColors.colors.inversePrimary,
              labelColor: AppColors.colors.inversePrimary,
              unselectedLabelColor: AppColors.colors.onSecondaryContainer,
              isScrollable: true,
              tabs: List<Widget>.generate(taskController.status.length,
                  (index) {
                return Tab(
                  child: Text(taskController.status[index]),
                );
              }),
            )
          ),)
        ),
        body: TabBarView(
          physics: const ClampingScrollPhysics(),
          children: tasks.map((_tasks) {
            return RefreshIndicator(
              onRefresh: _refresh,
              semanticsLabel: 'Actualizar tareas',
              semanticsValue: 'Actualizar tareas',
              child: FutureBuilder<List<Task?>>(
                future: _tasks,
                builder: (context, AsyncSnapshot<List<Task?>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return _taskCard(snapshot.data![index]!, context);
                        }
                      );
                    } else {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 100),
                        child: NoTaskWidget(text: 'No hay tareas agregadas')
                      );
                    }
                  } else {
                    return NoTaskWidget(text: 'No hay tareas agregadas');
                  }
                }
              ),
            );
          }).toList()
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'openAddTaskPage',
          elevation: 15,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))
          ),
          icon: const Icon(Icons.add),
          label: const Text('Agregar tarea'),
          onPressed: () {
            taskController.goToAddTaskPage(context);
          },
        ),
      ),
    );
  }

  Widget _taskCard(Task? task, BuildContext context) {

    late var datetime = DateFormat("yyyy-MM-dd").format(DateTime.parse(task?.deliveryDate ?? ''));

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          taskDetailPage(task),
          enableDrag: false,
          backgroundColor: AppColors.colors.secondaryContainer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 30),
          width: double.infinity,
          height: 100,
          decoration: _cardBorders(),
          child: Stack(
            alignment: Alignment.topLeft, children: [
              Positioned(left: 15, top: 40, child: _taskText(task?.name ?? '')),
              Positioned(child: _taskChecked(task?.id ?? '')),
              Positioned(top: 0, right: 0, child: _eventDate(datetime)),
            ]
          )
        )
      )
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: AppColors.colors.surface,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 6),
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

  Widget _taskChecked(String id) {
    return Obx( () => Transform.scale(
      scale: 1.2,
      child: Checkbox(
        overlayColor: MaterialStateProperty.all(AppColors.colors.tertiaryContainer),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: MaterialStateBorderSide.resolveWith(
          (states) => BorderSide(width: 1.5, color: AppColors.colors.onTertiaryContainer),
        ),
        activeColor: AppColors.colors.onTertiaryContainer,
        checkColor: AppColors.colors.tertiaryContainer,
        value: taskController.selectedTasks.contains(id),
        onChanged: (value) {
          setState(() {
            taskController.onTaskSelected(value, id);
            _refresh();
          });
        }
      ),
    ),);
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
        color: AppColors.colors.inversePrimary,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25)
        )
      )
    );
  }

  Widget taskDetailPage(Task? task) {

    late var datetime = DateFormat("yyyy-MM-dd").format(DateTime.parse(task?.deliveryDate ?? ''));

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.only(top: 20, bottom: 40, left: 30, right: 30),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 30),
                color: AppColors.colors.primary,
                onPressed: () {
                  Get.bottomSheet(
                    TaskUpdatePage(task: task),
                    enableDrag: true,
                    isDismissible: true,
                    isScrollControlled: true,
                    ignoreSafeArea: false,
                    backgroundColor: AppColors.colors.secondaryContainer,
                    barrierColor: Colors.black.withOpacity(0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 30),
                color: AppColors.colors.primary,
                onPressed: () {
                  taskController.confirmationDialog(context, task);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            (task?.name != '') ? task?.name ?? '' : "Sin nombre a tarea asignado",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 20),
          Text(
            (task?.description != '') ? task?.description ?? '' : "Sin descripción a tarea asignada",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Materia: ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
              ),
              Text(
                (task?.subject != '') ? task?.subject ?? '' : "No hay materia asignada",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Fecha de entrega: ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
              ),
              Text(
                (task?.deliveryDate != '') ? datetime : "Sin fecha de entrega asignada",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)
              ),
            ],
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
