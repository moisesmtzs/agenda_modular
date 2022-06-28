import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';

class HomeController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  HomeController() {
    print('${userSession.toJson()}');
  }

  void goToUpdatePage() {
    Get.toNamed('/updateProfile');
  }

  void goToSearchPage() {
    Get.toNamed('/search');
  }

  void logOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);
  }

  void confirmationDialog( BuildContext context ) {

    Widget cancelButton = ElevatedButton(
      onPressed: () {
        Get.back();
      },
      child: const Text('Cancelar')
    );

    Widget confirmButton = ElevatedButton(
      onPressed: () {
        logOut();
      },
      child: const Text('Confirmar')
    );

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('¿Estás seguro de que quieres cerrar sesión?'),
      actions: [
        cancelButton,
        confirmButton
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );

  }

}