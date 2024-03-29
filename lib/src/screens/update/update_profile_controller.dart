import 'dart:convert';
import 'dart:io';

import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/usersProvider.dart';

import '../../models/connectivity.dart';

class UpdateProfileController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  UsersProvider usersProvider = UsersProvider();

  var isEnable = true.obs;
  var isEnable2 = true.obs;
  var isLoading = false.obs;

  ImagePicker pickedFile = ImagePicker();
  File? imageFile;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Connect connectivity = Connect();

  UpdateProfileController() {
    connectivity.getConnectivityReplica();
    nameController.text = userSession.name ?? '';
    lastNameController.text = userSession.lastname ?? '';
    phoneController.text = userSession.phone ?? '';
  }

  void goToHomePage() {
    Get.offNamedUntil('/home', (route) => false);
  }

  void goToSearchPage() {
    Get.offNamedUntil('/search', (route) => false);
  }

  void deleteAccount() async {

    ResponseApi? responseApi = await usersProvider.deleteUser(userSession.id);
    if ( responseApi?.success == true ) {
      Get.snackbar(responseApi?.message ?? '', '');
      GetStorage().remove('user');
      Get.offNamedUntil('/', (route) => false);
    } else {
      Get.snackbar(
        'No se eliminó la cuenta',
        responseApi?.message ?? '',
        backgroundColor: AppColors.colors.errorContainer,
        colorText: AppColors.colors.onErrorContainer
      );
      isEnable2.value = true;
    }

  }

  void updateProfile( BuildContext context ) async {

    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text.trim();

    if ( isValidForm(name, lastName, phone) ) {

      isEnable.value = false;

      User user = User(
        id: userSession.id,
        name: name,
        lastname: lastName,
        phone: phone,
        sessionToken: userSession.sessionToken
      );

      if ( imageFile == null ) {
        ResponseApi? responseApi = await usersProvider.update(user);
        User? newUser = await usersProvider.getById(user.id);
        newUser?.sessionToken = userSession.sessionToken;
        if ( responseApi?.success == true ) {
          GetStorage().write('user', newUser?.toJson());
          Get.snackbar(
            'Actualización finalizada', 
            responseApi?.message ?? '',
            backgroundColor: AppColors.colors.secondary,
            colorText: AppColors.colors.onSecondary
          );
          isEnable.value = true;
        } else {
          isEnable.value = true;
        }
      } else {

        Stream? stream = await usersProvider.updateWithImage(user, imageFile!);

        stream?.listen((res) async {
          ResponseApi? responseApi = ResponseApi.fromJson(json.decode(res));
          
          User? newUser = await usersProvider.getById(user.id);
          newUser?.sessionToken = userSession.sessionToken;
          if (responseApi.success == true) {
            GetStorage().write('user', newUser?.toJson());
            Get.snackbar(
              'Actualización finalizada', 
              responseApi.message ?? '',
              backgroundColor: AppColors.colors.secondary,
              colorText: AppColors.colors.onSecondary
            );
            isEnable.value = true;
          } else {
            Get.snackbar(
              'Datos no válidos',
              responseApi.message ?? '',
              backgroundColor: AppColors.colors.errorContainer,
              colorText: AppColors.colors.onErrorContainer
            );
            isEnable.value = true;
          }
        });

      }

    }

  }

  bool isValidForm( String name, String lastName, String phone ) {

    if ( name.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un nombre");
      return false;
    }
    if ( lastName.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un apellido");
      return false;
    }
    if ( phone.isEmpty ) {
      Get.snackbar("Datos no válidos", "Debes ingresar un número de teléfono");
      return false;
    }
    return true;

  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await pickedFile.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void confirmationDialog( BuildContext context ) {

    Widget cancelButton = TextButton(
      onPressed: () {
        Get.back();
      },
      child: const Text('Cancelar')
    );

    Widget confirmButton = TextButton(
      onPressed: () {
        isEnable2.value = false;
        deleteAccount();
        Get.back();
      },
      child: const Text('Confirmar')
    );

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Eliminar cuenta'),
      content: const Text('¿Estás seguro de que quieres eliminar la cuenta?'),
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

  void showAlertDialog( BuildContext context ) {
    Widget galleryButton = TextButton(
      // style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(const Color(0xFF303F9F)) ),
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery);
      },
      child: const Text('GALERIA')
    );

    Widget cameraButton = TextButton(
      onPressed: () {
        selectImage(ImageSource.camera);
      },
      child: const Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Elegir imagen'),
      content: const Text('¿De dónde quieres tomar la imagen?'),
      actions: [
        galleryButton,
        cameraButton
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