import 'dart:io';

import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:get_storage/get_storage.dart';

//SQLITE//
import 'package:sqflite/sqflite.dart';
import 'package:agenda_app/src/api/db.dart';

class AddSubjectController extends GetxController {
  //VERIFICAR CONEXION A INTERNET//
  bool isConnect = false; 
  void GetConnectivity() async{
    try { 
      final result = await InternetAddress.lookup('google.com'); 
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) 
      { 
        print('CONECTADO'); 
        isConnect = true;
      }
    } on SocketException catch (_) { 
        print('SIN CONEXION'); 
        isConnect = false;
    }  
  }

  AddSubjectController()
  {
    GetConnectivity();
  }

  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  TextEditingController nameClassController = TextEditingController();
  TextEditingController codeClassController = TextEditingController();
  TextEditingController profesorClassController = TextEditingController();

  SubjectProvider subjectProvider = SubjectProvider();

  void register(BuildContext context) async {
    String idUser = userSession.id as String;
    String name = nameClassController.text;
    name = name.replaceFirst(name[0], name[0].toUpperCase());
    String code = codeClassController.text.trim();
    String profesor = profesorClassController.text;

    if (isValidForm(name, code, profesor)) {
      Subject subject = Subject(
          id_user: idUser,
          name: name,
          subject_code: code,
          professor_name: profesor);

      if(isConnect == true)
      {
        ResponseApi? responseApi = await subjectProvider.create(subject);
        if (responseApi?.success == true) {
          Get.snackbar(
            responseApi?.message ?? '', 
            'Materia creada correctamente',
            backgroundColor: AppColors.colors.secondary,
            colorText: AppColors.colors.onSecondary
          );
          Future.delayed(const Duration(milliseconds: 1000), () {
            Get.offNamed('/home');
          });
        } else {
          Get.snackbar('Datos no válidos', responseApi?.message ?? '',
              backgroundColor: Colors.red[200], colorText: Colors.white);
        }
      }
      else
      {
        //PENDIENTE DE REVISIÓN//
        Future<int?> ok = db.insertSubject(subject);  
        if(ok==0)
        {
          Get.snackbar('Hubo un problema al registrar la Materia', 'Intenta más tarde');
        }
        else
        {
          Get.snackbar('Materia registrada', '');
          Get.offNamed('/home'); 
        }   
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
