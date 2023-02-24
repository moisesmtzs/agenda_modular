import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class TaskController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final TasksProvider _tasksProvider = TasksProvider();

  List<String> status = <String>['PENDIENTE', 'COMPLETADO'].obs;
  
  var selectedTasks = [].obs;

  void goToAddTaskPage() {
    Get.toNamed('/addTask');
  }

  void onTaskSelected(bool? checked, String idTask) {
    if ( checked == true ) {
      selectedTasks.add(idTask);
      _tasksProvider.updateStatusTask(idTask, 'COMPLETADO');
      selectedTasks.refresh();
    } else {
      selectedTasks.remove(idTask);
      _tasksProvider.updateStatusTask(idTask, 'PENDIENTE');
      selectedTasks.refresh();
    }
  }

  void delete(String idTask) async {
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
        selectedTasks.remove(idTask);
        Get.back();
        Get.back();
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
    var tasks = await _tasksProvider.getByUserAndStatus(userSession.id ?? '0', status);
    if ( status == 'COMPLETADO' ) {
      for( int i = 0 ; i < tasks.length ; i++  ) {
        selectedTasks.add(tasks[i]!.id);
      }
    }
    return tasks;
  }
  
  // getTasks(String status) async {
  //     var tasks = await _tasksProvider.getByUserAndStatus(userSession.id ?? '0', status);
  //     if ( tasks.isNotEmpty ) {
  //       taskList.value = tasks;
  //     }
  // }
}