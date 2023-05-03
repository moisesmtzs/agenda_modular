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

  List<String> daysList = <String>[
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ].obs;

  List<String> hoursList = <String>[
    '07:00',
    '07:15',
    '07:30',
    '07:45',
    '08:00',
    '08:15',
    '08:30',
    '08:45',
    '09:00',
    '09:15',
    '09:30',
    '09:45',
    '10:00',
    '10:15',
    '10:30',
    '10:45',
    '11:00',
    '11:15',
    '11:30',
    '11:45',
    '12:00',
    '12:15',
    '12:30',
    '12:45',
    '13:00',
    '13:15',
    '13:30',
    '13:45',
    '14:00',
    '14:15',
    '14:30',
    '14:45',
    '15:00',
    '15:15',
    '15:30',
    '15:45',
    '16:00',
    '16:15',
    '16:30',
    '16:45',
    '17:00',
    '17:15',
    '17:30',
    '17:45',
    '18:00',
    '18:15',
    '18:30',
    '18:45',
    '19:00',
    '19:15',
    '19:30',
    '19:45',
    '20:00',
    '20:15',
    '20:30',
    '20:45',
    '21:00',
    '21:15',
    '21:30',
    '21:45',
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
    String? begin_hour = selectedBegin.value;
    String? end_hour = selectedEnd.value;
    String? days = selectedDay.value;
    String classroom = clasroomController.text;
    String building = buildingController.text;

    if (isValidForms(begin_hour, end_hour, days)) {
      clase.begin_hour = begin_hour;
      clase.end_hour = end_hour;
      clase.days = days;
      clase.building = building;
      clase.classroom = classroom;
      
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
          Get.offNamedUntil('/home', (route) => false);
        } else {
          Get.snackbar(responseApi.message ?? '',
              'Ha ocurrido un error al actualizar la clase',
              backgroundColor: AppColors.colors.errorContainer,
              colorText: AppColors.colors.onErrorContainer);
        }
      } else {
        int? res = await db.updateClase(clase);
        if (res != 0) {
          Get.snackbar('Clase actualizada',
              'La clase ha sido actualizada satisfactoriamente',
              backgroundColor: AppColors.colors.secondary,
              colorText: AppColors.colors.onSecondary);
          Get.offNamedUntil('/home', (route) => false);
        } else {
          Get.snackbar('Clase no actualizada',
              'Ha ocurrido un error al actualizar la clase',
              backgroundColor: AppColors.colors.errorContainer,
              colorText: AppColors.colors.onErrorContainer);
        }
        // Get.offNamed('/home');
      }
    }
  }

  bool isValidForms(String begin_hour, String end_hour, String days) {
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
    return true;
  }
}
