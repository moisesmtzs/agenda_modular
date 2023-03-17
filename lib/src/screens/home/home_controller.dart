import 'package:agenda_app/src/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';

import '../../models/connectivity.dart';

class HomeController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Connect connectivity = Connect();

  HomeController() {
    print(userSession.toJson());
    connectivity.getConnectivityReplica();
  }

  void goToUpdatePage() {
    Get.offNamedUntil('/updateProfile', (route) => false);
  }

  void goToSearchPage() {
    Get.offNamedUntil('/search', (route) => false);
  }

  void goToTaskPage(BuildContext context) {
    final page = TaskPage();
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    // Get.toNamed('/task');
  }

  void goToSchedulePage() {
    Get.toNamed('/schedule');
  }

  void goToSubject() {
    Get.toNamed('/subject');
  }

  void goToClase() {
    Get.toNamed('/clase');
  }

  void logOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);
  }

  void confirmationDialog(BuildContext context) {
    Widget cancelButton = TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Cancelar'));

    Widget confirmButton = TextButton(
        onPressed: () {
          logOut();
        },
        child: const Text('Confirmar'));

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Cerrar sesión'),
      content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
      actions: [cancelButton, confirmButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
