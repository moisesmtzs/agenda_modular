import 'package:agenda_app/src/screens/home/home_controller.dart';
import 'package:agenda_app/src/screens/tasks/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:agenda_app/src/api/db.dart';
import 'package:agenda_app/src/models/connectivity.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class AddTaskController extends GetxController {

  AddTaskController() {
    getSubjects();
    data.refresh();
  }

  //VALIDAR QUE EXISTE UNA CONEXION A INTERNET//
  Future validarInternet() async
  {
    await connectivity.getConnectivity();
  }
  
  Connect connectivity = Connect();

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  TasksProvider tasksProvider = TasksProvider();
  SubjectProvider subjectProvider = SubjectProvider();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  var value = DateTime.now().toString().obs;
  DateTime _selectedDate = DateTime.now();

  List<String> typeList = <String>['Actividad', 'Examen', 'Tarea'].obs;
  var typeSelected = ''.obs;

  List<Subject?> subjectList = <Subject?>[].obs;
  RxList<Subject?> data = <Subject?>[].obs;
  var subjectSelected = ''.obs;

  Future<List<Subject?>> getSubjects() async {
    await validarInternet();
    if ( connectivity.isConnected == true ) {
      subjectList = await subjectProvider.findByUser(userSession.id ?? '');
    } else {
      subjectList = await db.getSubjects();
    }

    for ( var s in subjectList ) {
      data.add(s);
    }
    return subjectList;
  }

  void register( BuildContext context ) async {

    String name = nameController.text;
    String description = descriptionController.text;
    String date = _selectedDate.toString();
    String subject = subjectSelected.string;
    String type = typeSelected.string;

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

      //GENERA REPLICA AL CREAR UN NUEVO REGISTRO//
      connectivity.getConnectivityReplica();

      if ( connectivity.isConnected == true ) {

        ResponseApi? responseApi = await tasksProvider.create(task);

        if (responseApi?.success == true) {
          Get.snackbar(
            responseApi?.message ?? '', 
            'La tarea ha sido creada satisfactoriamente',
            backgroundColor: AppColors.colors.secondary,
            colorText: AppColors.colors.onSecondary
          );
          Future.delayed(const Duration(milliseconds: 1000), () {
            Get.offNamedUntil('/home', (route) => false);
          });
        } else {
          Get.snackbar(
            'Datos no válidos',
            responseApi?.message ?? '',
            backgroundColor: AppColors.colors.errorContainer,
            colorText: AppColors.colors.onErrorContainer
          );
          // isEnable.value = true;
        }

      } else {

        task.status = "PENDIENTE";

        int? responseStatus = await db.insertTask(task);

        if ( responseStatus == 0 ) {
          Get.snackbar(
            'Datos no válidos',
            'No se pudo crear la tarea',
            backgroundColor: AppColors.colors.errorContainer,
            colorText: AppColors.colors.onErrorContainer
          );
          // isEnable.value = true;
        } else {
          Get.snackbar(
            'Tarea creada',
            '',
            backgroundColor: AppColors.colors.secondary,
            colorText: AppColors.colors.onSecondary
          );
          Future.delayed(const Duration(milliseconds: 800), () {
            Get.offNamedUntil('/home', (route) => false);
          });
        }

      }
      

    }

  }

  bool isValidForm( String name, String description, String date, String subject, String type ) {

    if ( name.isEmpty ) {
      Get.snackbar(
        "Datos no válidos", 
        "Debes ingresar un nombre a la tarea",
        backgroundColor: AppColors.colors.errorContainer,
        colorText: AppColors.colors.onErrorContainer
      );
      return false;
    }
    if ( description.isEmpty ) {
      Get.snackbar(
        "Datos no válidos", 
        "Debes ingresar una descripción",
        backgroundColor: AppColors.colors.errorContainer,
        colorText: AppColors.colors.onErrorContainer
      );
      return false;
    }
    if ( date.isEmpty ) {
      Get.snackbar(
        "Datos no válidos", 
        "Debes ingresar una fecha de entrega",
        backgroundColor: AppColors.colors.errorContainer,
        colorText: AppColors.colors.onErrorContainer
      );
      return false;
    }
    if ( subject.isEmpty ) {
      Get.snackbar(
        "Datos no válidos", 
        "Selecciona una materia",
        backgroundColor: AppColors.colors.errorContainer,
        colorText: AppColors.colors.onErrorContainer
      );
      return false;
    }
    if ( type.isEmpty ) {
      Get.snackbar(
        "Datos no válidos", 
        "Selecciona un tipo de tarea",
        backgroundColor: AppColors.colors.errorContainer,
        colorText: AppColors.colors.onErrorContainer
      );
      return false;
    }

    return true;

  }

  void showDatePick(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('es', 'ES'),
      initialDate: _selectedDate,
      firstDate: DateTime(2023), 
      lastDate: DateTime(2024),
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