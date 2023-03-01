import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class SubjectDetailController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final SubjectProvider _subjectProvider = SubjectProvider();

  void goToClase() {
    Get.toNamed('/clase');
  }

  void delete(String idSubject) async {
    ResponseApi? responseApi = await _subjectProvider.deleteSubject(idSubject);
    if (responseApi?.success == true) {
      Get.snackbar(responseApi?.message ?? '', '',
          backgroundColor: AppColors.colors.secondary,
          colorText: AppColors.colors.onSecondary);
    } else {
      Get.snackbar('No se eliminó la materia', responseApi?.message ?? '',
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer);
    }
  }

  void confirmationDialog(BuildContext context, String idTask) {
    Widget cancelButton = TextButton(
      child: const Text('Cancelar'),
      onPressed: () {
        Get.back();
      },
    );

    Widget continueButton = TextButton(
      child: const Text('Confirmar'),
      onPressed: () {
        delete(idTask);
        Get.back();
        Get.back();
      },
    );

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Borrar Materia'),
      content: const Text('¿Estás seguro de que quieres eliminar la materia?'),
      actions: [cancelButton, continueButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  //------------clases

  final ClaseProvider _claseProvider = ClaseProvider();
  

  Future<List<Clase?>> getClasesBySubject(String idSubject) async {
    return await _claseProvider.findByUserAndSubject(
        userSession.id ?? '0', idSubject);
  }
}
