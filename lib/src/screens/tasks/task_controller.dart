import 'package:agenda_app/src/api/db.dart';
import 'package:agenda_app/src/screens/home/home_controller.dart';
import 'package:agenda_app/src/screens/tasks/add_task/add_task_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/connectivity.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class TaskController extends GetxController {
  TaskController() {
    connectivity.getConnectivityReplica();
  }

  Future validarInternet() async {
    await connectivity.getConnectivity();
  }

  Connect connectivity = Connect();

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final TasksProvider _tasksProvider = TasksProvider();

  List<String> status = <String>["PENDIENTE", "COMPLETADO"].obs;

  var selectedTasks = [].obs;

  late Function refresh2;

  Future init(Function refresh2) async {
    this.refresh2 = refresh2;
  }

  void goToAddTaskPage(BuildContext context) {
    Get.toNamed('/addTask');
  }

  Future<List<Task?>> getTasks(String status) async {
    List<Task?> tasks = [];
    await connectivity.getConnectivity();
    if (connectivity.isConnected == true) {
      tasks = await _tasksProvider.getByUserAndStatus(userSession.id ?? '0', status);
    } else {
      tasks = await db.getTasksByStatus(status);
    }

    if (status == 'COMPLETADO') {
      for (int i = 0; i < tasks.length; i++) {
        if ( !selectedTasks.contains(tasks[i]!.id) ) {
          selectedTasks.add(tasks[i]!.id);
        }
      }
    }
    selectedTasks.refresh();
    refresh2();

    return tasks;

  }

  void onTaskSelected(bool? checked, String idTask) async {
    if (checked == true) {
      await validarInternet();
      if (connectivity.isConnected == true) {
        _tasksProvider.updateStatusTask(idTask, 'COMPLETADO');
        //GENERA REPLICA AL CREAR UN NUEVO REGISTRO//
        await connectivity.getConnectivityReplica();
      } else {
        db.updateTaskStatus(idTask, 'COMPLETADO');
      }
      selectedTasks.add(idTask);
      selectedTasks.refresh();
    }
    if (checked == false) {
      await validarInternet();
      if (connectivity.isConnected == true) {
        _tasksProvider.updateStatusTask(idTask, 'PENDIENTE');
        //GENERA REPLICA AL CREAR UN NUEVO REGISTRO//
        await connectivity.getConnectivityReplica();
      } else {
        db.updateTaskStatus(idTask, 'PENDIENTE');
      }

      selectedTasks.remove(idTask);
      selectedTasks.refresh();
    }
  }

  void delete(Task? task) async {
    await validarInternet();
    if (connectivity.isConnected == true) {
      ResponseApi? responseApi = await _tasksProvider.deleteTask(task!.id);
      //GENERA REPLICA AL CREAR UN NUEVO REGISTRO//
        await connectivity.getConnectivityReplica();
      if (responseApi?.success == true) {
        Get.snackbar(
          responseApi?.message ?? '', '',
          backgroundColor: AppColors.colors.secondary,
          colorText: AppColors.colors.onSecondary
        );
      } else {
        Get.snackbar(
          'No se eliminó la tarea', responseApi?.message ?? '',
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer
        );
      }
    } else {
      await db.deleteTask(task);
    }
  }

  void confirmationDialog(BuildContext context, Task? task) {
    Widget cancelButton = TextButton(
      child: const Text('Cancelar'),
      onPressed: () {
        Get.back();
      },
    );

    Widget continueButton = TextButton(
      child: const Text('Confirmar'),
      onPressed: () {
        delete(task);
        Get.back();
        Get.back();
        refresh2();
      },
    );

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Borrar tarea'),
      content: const Text('¿Estás seguro de que quieres eliminar la tarea?'),
      actions: [cancelButton, continueButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }
  
}
