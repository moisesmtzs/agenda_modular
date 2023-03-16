import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/api/db.dart';
import 'package:agenda_app/src/models/connectivity.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class ClaseDetailController extends GetxController {
  ClaseDetailController() {
    connectivity.getConnectivity(); //esto constructor
    // createReplica();
  }

  Connect connectivity = Connect(); //esto, constructor

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final ClaseProvider _claseProvider = ClaseProvider();

  void delete(Clase? clase) async {
    if (connectivity.isConnected == true) {
      ResponseApi? responseApi = await _claseProvider.deleteClase(clase!.id);
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
    } else {
      await db.deleteClase(clase);
    }
  }

  void confirmationDialog(BuildContext context, Clase? clase) {
    Widget cancelButton = TextButton(
      child: const Text('Cancelar'),
      onPressed: () {
        Get.back();
      },
    );

    Widget continueButton = TextButton(
      child: const Text('Confirmar'),
      onPressed: () {
        delete(clase);
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
