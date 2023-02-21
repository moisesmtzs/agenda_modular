import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class ClaseDetailController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final ClaseProvider _claseProvider = ClaseProvider();

  void delete(String idClase) async {
    ResponseApi? responseApi = await _claseProvider.deleteClase(idClase);
    if (responseApi?.success == true) {
      Get.snackbar(responseApi?.message ?? '', '',
          backgroundColor: AppColors.colors.secondary,
          colorText: AppColors.colors.onSecondary);
      refresh();
    } else {
      Get.snackbar('No se eliminó la clase', responseApi?.message ?? '',
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer);
    }
  }

  void confirmationDialog(BuildContext context, String idClase) {
    Widget cancelButton = TextButton(
      child: const Text('Cancelar'),
      onPressed: () {
        Get.back();
      },
    );

    Widget continueButton = TextButton(
      child: const Text('Confirmar'),
      onPressed: () {
        delete(idClase);
        Get.back();
        Get.back();
      },
    );

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Borrar clase'),
      content: const Text('¿Estás seguro de que quieres eliminar la clase?'),
      actions: [cancelButton, continueButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
