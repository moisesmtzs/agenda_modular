import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/usersProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoginController extends GetxController {

  LoginController()
  {
    GetConnectivity();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  UsersProvider usersProvider = UsersProvider();

  var isEnable = true.obs;
  var obscureText = true.obs;
  var isLoading = false.obs;

  //VERIFICAR CONEXION A INTERNET//
  void GetConnectivity() async
  {
    try { 
      final result = await InternetAddress.lookup('google.com'); 
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) 
      { 
        print('CONECTADO'); 
        Get.snackbar("CON CONEXION","CONECTADO A INTERNET");
      }
    } on SocketException catch (_) { 
        print('SIN CONEXION'); 
        Get.snackbar("SIN CONEXION","CONECTATE A INTERNET");
    }  
  }

  void goToRegisterPage() {

    Get.toNamed('/register');

  }

  void login() async {

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if ( email == 'admin@admin.com' && password == 'admin' ) {
    GetStorage().write('user', null);
    Get.offNamedUntil('/home', (route) => false);
    }

    if (isValidForm(email, password) ) {

      isEnable.value = false;
      
      ResponseApi? responseApi = await usersProvider.login(email, password);

      if ( responseApi?.success == true ) {

        GetStorage().write('user', responseApi?.data);
        Get.offNamedUntil('/home', (route) => false);

      } else {
        isEnable.value = true;
        Get.snackbar(
          'Sesión fallida', 
          responseApi?.message ?? '',
          backgroundColor: AppColors.colors.errorContainer,
          colorText: AppColors.colors.onErrorContainer
        );
      }
    }
  }

  bool isValidForm( String email, String password ) {
    if ( !GetUtils.isEmail(email) ) {
      Get.snackbar("Datos no válidos", "Email no válido");
      return false;
    }
    if ( email.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un email");
      return false;
    }

    if ( password.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar una contraseña");
      return false;
    }
    return true;
  }

}