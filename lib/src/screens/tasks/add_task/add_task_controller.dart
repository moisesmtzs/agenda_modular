import 'package:agenda_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';

class AddTaskController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  TasksProvider tasksProvider = TasksProvider();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  var value = DateTime.now().toString().obs;
  DateTime _selectedDate = DateTime.now();

  void register( BuildContext context ) async {

    String name = nameController.text;
    String description = descriptionController.text;
    String date = _selectedDate.toString();
    String subject = subjectController.text.trim();
    String type = typeController.text.trim();

    if ( isValidForm(name, description, date, subject, type) ) {

      // isEnable.value = false;

      Task task = Task(
        idUser: userSession.id,
        name: name,
        description: description,
        deliveryDate: date,
        subject: subject,
        type: type
      );
      
      ResponseApi? responseApi = await tasksProvider.create(task);

      if (responseApi?.success == true) {
        Get.snackbar(responseApi?.message ?? '', 'La tarea ha sido creada satisfactoriamente');
        Future.delayed(const Duration(milliseconds: 1000), () {
          Get.offAllNamed('/menu');
        });
      } else {
        Get.snackbar(
          'Datos no válidos',
          responseApi?.message ?? '',
          backgroundColor: Colors.red[200],
          colorText: Colors.white
        );
        // isEnable.value = true;
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
      // builder: (context, child) {
      //   return Theme(
      //     data: ThemeData.dark().copyWith(
      //       colorScheme: ColorScheme.dark(
      //         primary: Colors.indigo.shade200,
      //         onPrimary: Colors.white,
      //         surface: Colors.indigo.shade300,
      //         onSurface: Colors.orange.shade200,
      //       ),
      //       dialogTheme: const DialogTheme(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.all(Radius.circular(16))
      //         )
      //       ),
      //       dialogBackgroundColor:Colors.indigo.shade300,
      //       textButtonTheme: TextButtonThemeData(
      //         style: TextButton.styleFrom(
      //           primary: Colors.orange.shade200, 
      //           backgroundColor: Colors.black12, 
      //           textStyle: TextStyle(
      //             color: Colors.orange.shade200,
      //             fontWeight: FontWeight.normal,
      //             fontSize: 12,
      //             fontFamily: 'Quicksand'
      //           ),
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(16),
      //             side: const BorderSide(
      //               color: Colors.transparent,
      //               width: 1,
      //               style: BorderStyle.solid
      //             ),
      //           )
      //         ), 
      //       )
      //     ),
      //     child: child!,
      //   );
      // },
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