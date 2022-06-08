import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void goToRegisterPage() {

    Get.toNamed('/register');

  }

  void login() async {

    String email = emailController.text.trim();
    String password = emailController.text.trim();

    if ( isValidForm(email, password) ) {
      Get.snackbar("Datos válidos", "Sesión iniciada");
    }

  }

  bool isValidForm( String email, String password ) {

    // if ( !GetUtils.isEmail(email) ) {
    //   Get.snackbar("Datos no válidos", "Email no válido");
    //   return false;
    // }
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