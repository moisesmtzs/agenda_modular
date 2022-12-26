import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:agenda_app/src/models/class.dart';

import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/classProvider.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:get_storage/get_storage.dart';

class ClassController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  TextEditingController nameClassController = TextEditingController();
  TextEditingController codeClassController = TextEditingController();
  TextEditingController profesorClassController = TextEditingController();

  ClassProvider classProvider = ClassProvider();

  //void voidClass() {
  void register(BuildContext context) async {
    String idUser = userSession.id as String;
    String name = nameClassController.text;
    String code = codeClassController.text.trim();
    String profesor = profesorClassController.text;

    if (isValidForm(name, code, profesor)) {
      Class clase = Class(
          id_user: idUser,
          name: name,
          subject_code: code,
          professor_name: profesor);

      ResponseApi? responseApi = await classProvider.create(clase);
      Get.snackbar('', 'Entro');
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

  bool isValidForm(String name, String code, String profesor) {
    if (name.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar un nombre");
      return false;
    }
    if (code.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar un codigo");
      return false;
    }
    if (profesor.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar un nombre de profesor");
      return false;
    }

    return true;
  }
}

//-----------------------------------------------------------------------------------------------------
//CLASE PARA DATOS DE TABLA SCHEDULE

class ScheduleinterController extends GetxController {
  String? begineController;
  String? endController;
  String? daysController;
  TextEditingController clasroomController = TextEditingController();
  TextEditingController buildingController = TextEditingController();

  void register(BuildContext context) async {
    String? inicio = begineController;
    String? fin = endController;
    String? days = daysController;
    String clasroom = clasroomController.text;
    String building = buildingController.text;

    if (isValidForms(inicio!, fin!, days!, clasroom, building)) {
      Get.snackbar('Inicio: ', inicio);
      Get.snackbar('Fin: ', fin);
      Get.snackbar('Dias: ', days);
      Get.snackbar('Salon: ', clasroom);
      Get.snackbar('Modulo: ', building);
    }
  }

  bool isValidForms(String inicio, String fin, String days, String clasroom,
      String building) {
    if (inicio.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar una hora de inicio");
      return false;
    }
    if (fin.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar una hora de fin");
      return false;
    }
    if (days.isEmpty) {
      Get.snackbar("Datos no válidos",
          "Debe ingresar los dias con el siguiente formato -> (l m i j v s)");
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
