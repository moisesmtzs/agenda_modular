import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:get_storage/get_storage.dart';

class ClaseController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  String? begineController;
  String? endController;
  String? daysController;
  TextEditingController clasroomController = TextEditingController();
  TextEditingController buildingController = TextEditingController();

  ClaseProvider claseProvider = ClaseProvider();

  void register(BuildContext context) async {
    String idUser = userSession.id as String;
    String? inicio = begineController;
    String? fin = endController;
    String? days = daysController;
    String clasroom = clasroomController.text;
    String building = buildingController.text;

    if (isValidForms(inicio!, fin!, days!, clasroom, building)) {
      Clase clase = Clase(
        id_user: idUser,
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
          Get.offNamed('/clase');
        });
      } else {
        Get.snackbar('Datos no válidos', responseApi?.message ?? '',
            backgroundColor: Colors.red[200], colorText: Colors.white);
      }
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
