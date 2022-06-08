import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RegisterController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void register() async {

    String name = nameController.text;
    String lastName = lastNameController.text;
    String phone = phoneController.text;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if ( isValidForm(name, lastName, phone, email, password, confirmPassword) ) {
      Get.snackbar("Datos válidos", "Sesión iniciada");
    }

  }

  bool isValidForm( String email, String password, String confirmPassword, String name, String lastName, String phone ) {

    // if ( !GetUtils.isEmail(email) ) {
    //   Get.snackbar("Datos no válidos", "Email no válido");
    //   return false;
    // }
    if ( name.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un email");
      return false;
    }
    if ( lastName.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un email");
      return false;
    }
    if ( phone.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un email");
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
    if ( confirmPassword.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar una contraseña");
      return false;
    }
    return true;

  }

}