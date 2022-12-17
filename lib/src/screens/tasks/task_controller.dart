import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';
import 'package:agenda_app/src/screens/tasks/detail/tasks_detail_page.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class TaskController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final TasksProvider _tasksProvider = TasksProvider();

  List<String> status = <String>['PENDIENTE', 'COMPLETADO'].obs;

  var isSelected = false.obs;
  bool? isUpdated;

  void openBottomSheet(BuildContext context, Task task) async {

    isUpdated = await showMaterialModalBottomSheet(
      enableDrag: false,
      backgroundColor: AppColors.colors.secondaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      context: context, 
      builder: (context) => TaskDetailPage(task: task)
    ); 

  }

  void goToAddTaskPage() {
    Get.toNamed('/addTask');
  }
  
  Future<List<Task?>> getTasks(String status) async {
    return await _tasksProvider.getByUserAndStatus(userSession.id ?? '0', status);
  }

}