import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/api/db.dart';
import 'package:agenda_app/src/models/connectivity.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/models/user.dart';

import 'package:agenda_app/src/providers/claseProvider.dart';

class ClaseUpdateController extends GetxController {
  ClaseUpdateController(this.clase) {
    connectivity.getConnectivity();
    getClase();
    setClase();
  }

  Clase clase = Clase();
  Connect connectivity = Connect();

  //VALIDAR QUE EXISTE UNA CONEXION A INTERNET//
  Future validarInternet() async {
    await connectivity.getConnectivity();
  }

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  String? begineController;
  String? endController;
  String? daysController;
  TextEditingController clasroomController = TextEditingController();
  TextEditingController buildingController = TextEditingController();

  ClaseProvider claseProvider = ClaseProvider();
  //RxList<Subject?> subjects = <Subject?>[].obs;

  List<String> daysList = <String>[
    'lunes',
    'martes',
    'miercoles',
    'jueves',
    'viernes',
    'sabado'
  ].obs;

  


  List<String> hoursList = <String>[
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00'
  ].obs;

  var selectedBegin = ''.obs; //hora de inicio
  var selectedEnd = ''.obs; //hora de fin
  var selectedDay = ''.obs; //dia seleccionado

  var value = DateTime.now().toString().obs;

  List<Clase?> claseList = <Clase?>[].obs;
  RxList<Clase?> data = <Clase?>[].obs;

  Future<List<Clase?>> getClase() async {
    await validarInternet();

    if (connectivity.isConnected == true) {
      claseList = await claseProvider.findByUser(userSession.id ?? '');
      //GENERA REPLICA AL CREAR UN NUEVO REGISTRO//
      await connectivity.getConnectivityReplica();
    } else {
      claseList = await db.getClases();
    }

    for (var s in claseList) {
      data.add(s);
    }

    return claseList;
  }

  void setClase() {
    selectedBegin.value = clase.begin_hour!;
    selectedEnd.value = clase.end_hour!;
    selectedDay.value = clase.days!;
    clasroomController.text = clase.classroom!;
    buildingController.text = clase.building!;
  }

  void updateClase(BuildContext context) async {
    String? begin_hour = selectedBegin.value ;
    String? end_hour = selectedEnd.value;
    String? days = selectedDay.value;
    String classroom = clasroomController.text;
    String building = buildingController.text;

    if (isValidForms(begin_hour, end_hour, days, classroom, building)) {
      clase.begin_hour = begin_hour;
      clase.end_hour = end_hour;
      clase.days = days;
      clase.classroom = classroom;
      clase.building = building;

      await validarInternet();

      if (connectivity.isConnected == true) {
        ResponseApi? responseApi = await claseProvider.updateClase(clase);
        //GENERA REPLICA AL CREAR UN NUEVO REGISTRO//
        await connectivity.getConnectivityReplica();
        if (responseApi!.success!) {
          Get.snackbar(responseApi.message ?? '',
              'La clase ha sido actualizada satisfactoriamente',
              backgroundColor: AppColors.colors.secondary,
              colorText: AppColors.colors.onSecondary);
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
          Get.offNamed('/subject');
        } else {
          Get.snackbar(responseApi.message ?? '',
              'Ha ocurrido un error al actualizar la clase',
              backgroundColor: AppColors.colors.errorContainer,
              colorText: AppColors.colors.onErrorContainer);
        }
      } else {
        await db.updateClase(clase);
      }
    }
  }

  bool isValidForms(String begin_hour, String end_hour, String days,
      String classroom, String building) {
    if (begin_hour.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar una hora de inicio",
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer);
      return false;
    }
    if (end_hour.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar una hora de fin",
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer);
      return false;
    }
    if (days.isEmpty) {
      Get.snackbar("Datos no válidos", "Debe seleccionar un dia",
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer);
      return false;
    }
    if (classroom.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar el numero de salon",
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer);
      return false;
    }
    if (building.isEmpty) {
      Get.snackbar(
          "Datos no válidos", "Debes ingresar la letra o nombre del edificio",
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer);
      return false;
    }
    return true;
  }
}
