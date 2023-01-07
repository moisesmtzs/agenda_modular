import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:get_storage/get_storage.dart';

class SubjectController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  TextEditingController nameClassController = TextEditingController();
  TextEditingController codeClassController = TextEditingController();
  TextEditingController profesorClassController = TextEditingController();

  SubjectProvider subjectProvider = SubjectProvider();

  void register(BuildContext context) async {
    String idUser = userSession.id as String;
    String name = nameClassController.text;
    String code = codeClassController.text.trim();
    String profesor = profesorClassController.text;

    if (isValidForm(name, code, profesor)) {
      Subject subject = Subject(
          id_user: idUser,
          name: name,
          subject_code: code,
          professor_name: profesor);
      ResponseApi? responseApi = await subjectProvider.create(subject);
      Get.snackbar('', 'Entro');
      if (responseApi?.success == true) {
        Get.snackbar(
            responseApi?.message ?? '', 'Materia creada correctamente');
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
