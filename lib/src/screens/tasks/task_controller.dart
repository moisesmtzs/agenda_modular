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

  var isSelected = false.obs;
  var taskList = <Task?>[].obs;

  void goToAddTaskPage() {
    Get.toNamed('/addTask');
  }
  
  Future<List<Task?>> getTasks(String status) async {
    return await _tasksProvider.getByUserAndStatus(userSession.id ?? '0', status);
  }
  
  // getTasks(String status) async {
  //     var tasks = await _tasksProvider.getByUserAndStatus(userSession.id ?? '0', status);
  //     if ( tasks.isNotEmpty ) {
  //       taskList.value = tasks;
  //     }
  // }
}