import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';

class ClaseController extends GetxController {
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
