import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:get_storage/get_storage.dart';

class ClaseController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  String? idsubject;
  String? begineController;
  String? endController;
  String? daysController;
  TextEditingController clasroomController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  SubjectProvider subjectProvider = SubjectProvider();

  //dropdown
  List<Subject?> subjects = <Subject>[].obs;

  ClaseController() {
    getSubjects();
  }

  void getSubjects() async {
    var result = await subjectProvider.findByUser(userSession.id as String);
    subjects.clear();
    subjects.addAll(result);
  }

  ClaseProvider claseProvider = ClaseProvider();

  void register(BuildContext context) async {
    String idUser = userSession.id as String;
    String? idSubject = idsubject;
    String? inicio = begineController;
    String? fin = endController;
    String? days = daysController;
    String clasroom = clasroomController.text;
    String building = buildingController.text;

    if (isValidForms(idSubject!, inicio!, fin!, days!, clasroom, building)) {
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
        Get.snackbar(responseApi?.message ?? '', 'Clase creada correctamente');
        Future.delayed(const Duration(milliseconds: 1000), () {
          Get.offNamed('/schedule');
        });
      } else {
        Get.snackbar('Datos no válidos', responseApi?.message ?? '',
            backgroundColor: Colors.red[200], colorText: Colors.white);
      }
    }
  }

  bool isValidForms(String idSubject, String inicio, String fin, String days,
      String clasroom, String building) {
    if (idSubject.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes seleccionar una materia");
      return false;
    }
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
    if (clasroom.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar el numero de salon");
      return false;
    }
    if (building.isEmpty) {
      Get.snackbar(
          "Datos no válidos", "Debes ingresar la letra o nombre del edificio");
      return false;
    }
    return true;
  }
}
