import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/api/db.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

import '../../../models/connectivity.dart';
import '../../../models/subject.dart';

class SubjectDetailController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  Connect connectivity = Connect();

  final SubjectProvider _subjectProvider = SubjectProvider();

  void goToClase() {
    Get.toNamed('/clase');
  }

  SubjectDetailController()
  {
    connectivity.getConnectivity();
  }

  //VALIDAR QUE EXISTE UNA CONEXION A INTERNET//
  Future validarInternet() async
  {
    await connectivity.getConnectivity();
  }

  void delete(Subject subject) async {
    //GENERA LA REPLICA AL ELIMINAR UN REGISTRO//
    await connectivity.getConnectivityReplica();

    if ( connectivity.isConnected == true ) {
      ResponseApi? responseApi = await _subjectProvider.deleteSubject(subject.id);
      if (responseApi?.success == true) {
        Get.snackbar(responseApi?.message ?? '', '',
            backgroundColor: AppColors.colors.secondary,
            colorText: AppColors.colors.onSecondary);
        Future.delayed(const Duration(milliseconds: 1000), () {//Funciona pero se puede mejorar RETORNA AL MAIN, CUANDO SE ELIMINA UNA MATERIA
        Get.offNamed('/home');
        });
      } else {
        Get.snackbar('No se eliminó la materia', responseApi?.message ?? '',
            backgroundColor: AppColors.colors.errorContainer,
            colorText: AppColors.colors.onErrorContainer);
      }
    }
    else
    {
      await db.deleteSubject(subject);
    } 
  }

  void confirmationDialog(BuildContext context, Subject task) {
    Widget cancelButton = TextButton(
      child: const Text('Cancelar'),
      onPressed: () {
        Get.back();
      },
    );

    Widget continueButton = TextButton(
      child: const Text('Confirmar'),
      onPressed: () {
        delete(task);
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
    //GENERA LA REPLICA AL ELIMINAR UN REGISTRO//
    await connectivity.getConnectivityReplica();
    if(connectivity.isConnected == true)
    {
      return await _claseProvider.findByUserAndSubject(
          userSession.id ?? '0', idSubject);
    }
    else
    {
      print("AQUI VAN LAS CLASES DESDE LA BD LOCAL");
      return await _claseProvider.findByUserAndSubject(
          userSession.id ?? '0', idSubject);
    }
  }
}
