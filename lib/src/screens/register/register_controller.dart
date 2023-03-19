import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/providers/usersProvider.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

import '../../models/connectivity.dart';

class RegisterController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  Connect connectivity = Connect();

  var isEnable = true.obs;
  var isLoading = false.obs;
  var obscureText = true.obs;
  var obscureText2 = true.obs;

  void register( BuildContext context ) async {

    String name = nameController.text;
    String lastName = lastNameController.text;
    String phone = phoneController.text;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if ( isValidForm(name, lastName, phone, email, password, confirmPassword) ) {

      //VERIFICAR CONEXION A INTERNET//
      await connectivity.getConnectivity();

      isEnable.value = false;

      User user = User(
        name: name,
        lastname: lastName,
        phone: phone,
        email: email,
        password: password
      );
      
      if(connectivity.isConnected==true)
      {
        ResponseApi? responseApi = await usersProvider.create(user);

        if (responseApi?.success == true) {
          Get.snackbar(responseApi?.message ?? '', 'Inicia sesión');
          Future.delayed(const Duration(milliseconds: 1000), () {
            Get.offNamed('/');
          });
        } else {
          Get.snackbar(
            'Datos no válidos',
            responseApi?.message ?? '',
            backgroundColor: AppColors.colors.errorContainer,
            colorText: AppColors.colors.onErrorContainer
          );
          isEnable.value = true;
          isEnable.refresh();
        }
      }
      else
      {
        Get.snackbar('No ha sido posible conectarse al Servidor', 'Sin conexion a Internet"');
      }

    }

  }

  bool isValidForm( String name, String lastName, String phone, String email, String password, String confirmPassword ) {

    if ( !GetUtils.isEmail(email) ) {
      Get.snackbar("Datos no válidos", "Email no válido");
      return false;
    }
    if ( name.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un nombre");
      return false;
    }
    if ( lastName.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar los apellidos");
      return false;
    }
    if ( phone.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un número de teléfono");
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
      Get.snackbar("Datos no válidos", "Debes ingresar la confirmación de la contraseña");
      return false;
    }
    if ( password != confirmPassword ) {
      Get.snackbar('Las contraseñas no coinciden', 'Intenta de nuevo');
      return false;
    }

    return true;

  }

}