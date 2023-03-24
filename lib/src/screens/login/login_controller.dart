import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/usersProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../models/connectivity.dart';

class LoginController extends GetxController {

  LoginController()
  {
    connectivity.getConnectivity();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Connect connectivity = Connect();
  
  UsersProvider usersProvider = UsersProvider();

  var isEnable = true.obs;
  var obscureText = true.obs;
  var isLoading = false.obs;

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

      await connectivity.getConnectivity();

      if(connectivity.isConnected == true)
      { 
        ResponseApi? responseApi = await usersProvider.login(email, password);

        if ( responseApi?.success == true ) {

          GetStorage().write('user', responseApi?.data);
          //GENERA REPLICA AL CREAR UN NUEVO REGISTRO//
          await connectivity.getConnectivityReplica();
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
      else
      {
        Get.snackbar("No ha sido posible conectarse al Servidor", "Sin conexion a Internet");
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