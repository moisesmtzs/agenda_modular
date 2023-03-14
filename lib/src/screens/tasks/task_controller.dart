import 'package:agenda_app/src/api/db.dart';
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
    connectivity.getConnectivity();
  }

  Connect connectivity = Connect();

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final TasksProvider _tasksProvider = TasksProvider();

  List<String> status = <String>['PENDIENTE', 'COMPLETADO'].obs;
  
  var selectedTasks = [].obs;

  late Function refresh2;

  Future init(Function refresh2) async {
    this.refresh2 = refresh2;
  }

  void goToAddTaskPage() {
    Get.toNamed('/addTask');
  }

  void onTaskSelected(bool? checked, String idTask) {
    if ( checked == true ) {

      if ( connectivity.isConnected == true ) {
        _tasksProvider.updateStatusTask(idTask, 'COMPLETADO');
      } else {
        db.updateTaskStatus(idTask, 'COMPLETADO');
      }

      selectedTasks.add(idTask);
      selectedTasks.refresh();

    }
    if ( checked == false ) {
      
      if ( connectivity.isConnected == true ) {
        _tasksProvider.updateStatusTask(idTask, 'PENDIENTE');
      } else {
        db.updateTaskStatus(idTask, 'PENDIENTE');
      }
      
      selectedTasks.remove(idTask);
      selectedTasks.refresh();
    }
  }

  void delete(String idTask) async {

    if ( connectivity.isConnected == true ) {
      ResponseApi? responseApi = await _tasksProvider.deleteTask(idTask);
      if ( responseApi?.success == true ) {
        Get.snackbar(
          responseApi?.message ?? '', 
          '',
          backgroundColor: AppColors.colors.secondary,
          colorText: AppColors.colors.onSecondary
        );
      } else {
        Get.snackbar(
          'No se eliminó la tarea',
          responseApi?.message ?? '',
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer
        );
      }
    } else {
      await db.deleteTask(idTask);
    }
     
  }

  void confirmationDialog(BuildContext context, String idTask) {
    Widget cancelButton = TextButton(
      child: const Text('Cancelar'),
      onPressed: () {
        Get.back();
      },
    );
    
    Widget continueButton = TextButton(
      child: const Text('Confirmar'),
      onPressed: () {
        delete(idTask);
        Get.back();
        Get.back();
        refresh2();
      },
    );
    
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Borrar tarea'),
      content: const Text('¿Estás seguro de que quieres eliminar la tarea?'),
      actions: [
        cancelButton,
        continueButton
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );

  }
  
  Future<List<Task?>> getTasks(String status) async {

    List<Task?> tasks = [];
    if ( connectivity.isConnected == true ) {
      return tasks = await _tasksProvider.getByUserAndStatus(userSession.id ?? '0', status);
    } else {
      tasks = await db.getTasksByStatus(status);
    }

    if ( status == 'COMPLETADO' ) {
      for( int i = 0 ; i < tasks.length ; i++  ) {
        selectedTasks.add(tasks[i]!.id);
      }
    }
    selectedTasks.refresh();
    refresh2();
    return tasks;
  }
  
  // getTasks(String status) async {
  //     var tasks = await _tasksProvider.getByUserAndStatus(userSession.id ?? '0', status);
  //     if ( tasks.isNotEmpty ) {
  //       taskList.value = tasks;
  //     }
  // }
}