import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';

class SubjectUpdateController extends GetxController {
  Subject subject = Subject();
  SubjectUpdateController(this.subject) {
    setSubject();
  }

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  SubjectProvider subjectProvider = SubjectProvider();

  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController professorController = TextEditingController();

  var value = DateTime.now().toString().obs;

  void setSubject() {
    nameController.text = subject.name!;
    codeController.text = subject.subject_code!;
    professorController.text = subject.professor_name!;
  }

  void updateSubject(BuildContext context) async {
    String name = nameController.text;
    name = name.replaceFirst(name[0], name[0].toUpperCase());
    String subject_code = codeController.text.trim();
    String professor_name = professorController.text;

    if (isValidForm(name, subject_code, professor_name)) {
      subject.name = name;
      subject.subject_code = subject_code;
      subject.professor_name = professor_name;

      ResponseApi? responseApi = await subjectProvider.updateSubject(subject);
      if (responseApi!.success!) {
        Get.snackbar(responseApi.message ?? '',
            'La materia ha sido actualizada satisfactoriamente',
            backgroundColor: AppColors.colors.secondary,
            colorText: AppColors.colors.onSecondary);
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        Get.snackbar(responseApi.message ?? '',
            'Ha ocurrido un error al actualizar la materia',
            backgroundColor: AppColors.colors.errorContainer,
            colorText: AppColors.colors.onErrorContainer);
      }
    }
  }

  bool isValidForm(String name, String subject_code, String professor_name) {
    if (name.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar un nombre a la materia");
      return false;
    }
    if (subject_code.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar un codigo");
      return false;
    }
    if (professor_name.isEmpty) {
      Get.snackbar("Datos no válidos", "Debes ingresar un nombre de profesor");
      return false;
    }

    return true;
  }
}
