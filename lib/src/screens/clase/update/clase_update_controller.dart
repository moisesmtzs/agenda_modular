import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';

class ClaseUpdateController extends GetxController {
  Clase clase = Clase();
  ClaseUpdateController(this.clase) {
    setClase();
  }

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  ClaseProvider claseProvider = ClaseProvider();

  String? begineController;
  String? endController;
  String? daysController;
  TextEditingController clasroomController = TextEditingController();
  TextEditingController buildingController = TextEditingController();

  var value = DateTime.now().toString().obs;

  void setClase() {
    begineController = clase.begin_hour!;
    endController = clase.end_hour!;
    daysController = clase.days!;
    clasroomController.text = clase.classroom!;
    buildingController.text = clase.building!;
  }

  void updateClase(BuildContext context) async {
    String? begin_hour = begineController;
    String? end_hour = endController;
    String? days = daysController;
    String classroom = clasroomController.text;
    String building = buildingController.text;

    if (isValidForms(begin_hour!, end_hour!, days!, classroom, building)) {
      clase.begin_hour = begin_hour;
      clase.end_hour = end_hour;
      clase.days = days;
      clase.classroom = classroom;
      clase.building = building;

      ResponseApi? responseApi = await claseProvider.updateClase(clase);
      if (responseApi!.success!) {
        Get.snackbar(responseApi.message ?? '',
            'La clase ha sido actualizada satisfactoriamente',
            backgroundColor: AppColors.colors.secondary,
            colorText: AppColors.colors.onSecondary);
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        Get.snackbar(responseApi.message ?? '',
            'Ha ocurrido un error al actualizar la clase',
            backgroundColor: AppColors.colors.errorContainer,
            colorText: AppColors.colors.onErrorContainer);
      }
    }
  }

  bool isValidForms(String begin_hour, String end_hour, String days,
      String classroom, String building) {
    if (begin_hour.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar una hora de inicio");
      return false;
    }
    if (end_hour.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar una hora de fin");
      return false;
    }
    if (days.isEmpty) {
      Get.snackbar("Datos no válidos", "Debe seleccionar un dia");
      return false;
    }
    if (classroom.isEmpty) {
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
