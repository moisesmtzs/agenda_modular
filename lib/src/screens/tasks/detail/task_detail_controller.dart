import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class TaskDetailController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final TasksProvider _tasksProvider = TasksProvider();

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

}