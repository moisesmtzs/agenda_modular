import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';

class TaskUpdateController extends GetxController {

  Task task = Task();
  // TaskUpdateController({required this.task});
  TaskUpdateController(this.task) {
    setTask();
  }

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  TasksProvider tasksProvider = TasksProvider();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  var value = DateTime.now().toString().obs;
  DateTime _selectedDate = DateTime.now();

  void setTask() {
    nameController.text = task.name!;
    descriptionController.text = task.description!;
    subjectController.text = task.subject!;
    typeController.text = task.type!;
    _selectedDate = DateTime.parse(task.deliveryDate ?? '');
    value.value = _selectedDate.toString();
  }

  void updateTask(BuildContext context) async {

    String name = nameController.text;
    String description = descriptionController.text;
    String date = _selectedDate.toString();
    String subject = subjectController.text.trim();
    String type = typeController.text.trim();

    if (isValidForm(name, description, date, subject, type)) {
      
      task.name = name;
      task.description = description;
      task.deliveryDate = date;
      task.subject = subject;
      task.type = type;

      ResponseApi? responseApi = await tasksProvider.updateTask(task);
      if( responseApi!.success! ) {
        Get.snackbar(
          responseApi.message ?? '',
          'La tarea ha sido actualizada satisfactoriamente',
          backgroundColor: AppColors.colors.secondary,
          colorText: AppColors.colors.onSecondary
        );
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        Get.snackbar(
          responseApi.message ?? '', 
          'Ha ocurrido un error al actualizar la tarea',
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer
        );
      }

    }

  }

  bool isValidForm( String name, String description, String date, String subject, String type ) {

    if ( name.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un nombre a la tarea");
      return false;
    }
    if ( description.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar una descripción");
      return false;
    }
    if ( date.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar una fecha de entrega");
      return false;
    }
    if ( subject.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar una materia");
      return false;
    }
    if ( type.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un tipo de tarea");
      return false;
    }

    return true;

  }

  void showDatePick(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('es', 'ES'),
      initialDate: _selectedDate,
      firstDate: DateTime(2022), 
      lastDate: DateTime(2023),
    );
    if(picked != null && picked != _selectedDate) {
      value.value = picked.toString();
      _selectedDate = picked;
    } 
  }

  String convertDateTimeDisplay(String? date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date ?? '');
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

}