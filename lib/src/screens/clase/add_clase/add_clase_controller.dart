import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:get_storage/get_storage.dart';

class ClaseController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  var idsubject = ''.obs;
  String? begineController;
  String? endController;
  String? daysController;
  TextEditingController clasroomController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  SubjectProvider subjectProvider = SubjectProvider();

  //dropdown
  RxList<Subject?> subjects = <Subject?>[].obs;

  ClaseController() {
    getSubjects();
    subjects.refresh();
    daysController = "lunes";
  }

  void getSubjects() async {
    var result = await subjectProvider.findByUser(userSession.id as String);
    subjects.clear();
    for (var s in result) {
      subjects.add(s!);
    }
  }

  ClaseProvider claseProvider = ClaseProvider();

  void register(BuildContext context) async {
    String idUser = userSession.id as String;
    String? idSubject = idsubject.string;
    String inicio = "0001-01-01 " + begineController.toString() + ":00";
    String fin = "0001-01-01 " + endController.toString() + ":00";
    String? days = daysController;
    String clasroom = clasroomController.text;
    String building = buildingController.text;

    if (isValidForms(idSubject, inicio, fin, days!)) {
      Clase clase = Clase(
        id_user: idUser,
        id_subject: idSubject,
        begin_hour: inicio,
        end_hour: fin,
        days: days,
        classroom: clasroom,
        building: building,
      );

      ResponseApi? responseApi = await claseProvider.create(clase);
      if (responseApi?.success == true) {
        Get.snackbar(responseApi?.message ?? '', 'Clase creada correctamente',
            backgroundColor: AppColors.colors.secondary,
            colorText: AppColors.colors.onSecondary);
        Future.delayed(const Duration(milliseconds: 1000), () {
          Get.offNamed('/home');
        });
      } else {
        Get.snackbar('Datos no válidos', responseApi?.message ?? '',
            backgroundColor: Colors.red[200], colorText: Colors.white);
      }
    }
  }

  bool isValidForms(String idSubject, String inicio, String fin, String days) {
    // if (idSubject.isEmpty) {//INECESARIO, SIEMPRE TENDRA IM ID DE USUARIO
    //   Get.snackbar("Datos no válidos", "Debes seleccionar una materia");
    //   return false;
    // }
    if (inicio.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes seleccionar una hora de inicio");
      return false;
    }
    if (fin.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes seleccionar una hora de fin");
      return false;
    }
    if (days.isEmpty) {
      Get.snackbar("Datos no válidos", "Debe seleccionar un dia");
      return false;
    }
    //Verificamos si la hora de inicio es antes que la de salida
    int ini = int.parse(inicio.substring(11, 13));
    int fi = int.parse(fin.substring(11, 13));
    if (ini > fi) {
      Get.snackbar("Horas invalidas", "Verifica tu hora de inicio y de salida");
      return false;
    }
    return true;
  }
}
