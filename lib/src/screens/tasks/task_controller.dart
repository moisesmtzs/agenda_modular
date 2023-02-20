import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';

class TaskController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final TasksProvider _tasksProvider = TasksProvider();

  List<String> status = <String>['PENDIENTE', 'COMPLETADO'].obs;

  var selectedTasks = [].obs;
  RxList<Task?> taskList = <Task?>[].obs;

  void goToAddTaskPage() {
    Get.toNamed('/addTask');
  }

  void onTaskSelected(bool? checked, String idTask) {
    if ( checked == true ) {
      selectedTasks.value.add(idTask);
      _tasksProvider.updateStatusTask(idTask, 'COMPLETADO');
      selectedTasks.refresh();
    } else {
      selectedTasks.value.remove(idTask);
      _tasksProvider.updateStatusTask(idTask, 'PENDIENTE');
      selectedTasks.refresh();
    }
  }
  
  Future<List<Task?>> getTasks(String status) async {
    var tasks = await _tasksProvider.getByUserAndStatus(userSession.id ?? '0', status);
    if ( status == 'COMPLETADO' ) {
      for( int i = 0 ; i < tasks.length ; i++  ) {
        selectedTasks.value.add(tasks[i]!.id);
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