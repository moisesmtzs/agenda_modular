import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/usersProvider.dart';

class UpdateProfileController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final UsersProvider _usersProvider = UsersProvider();

  var isEnable = true.obs;
  var isEnable2 = true.obs;
  var isLoading = false.obs;
  var isLoading2 = false.obs;

  ImagePicker pickedFile = ImagePicker();
  File? imageFile;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  UpdateProfileController() {
    nameController.text = userSession.name ?? '';
    lastNameController.text = userSession.lastname ?? '';
    phoneController.text = userSession.phone ?? '';
  }

  void goToHomePage() {

    Get.offNamedUntil('/home', (route) => false);

  }

  void deleteAccount() async {

    ResponseApi? responseApi = await _usersProvider.deleteUser(userSession.id);
    if ( responseApi?.success == true ) {
      Get.snackbar(responseApi?.message ?? '', '');
      GetStorage().remove('user');
      Get.offNamedUntil('/', (route) => false);
    } else {
      Get.snackbar(
        'No se eliminó la cuenta',
        responseApi?.message ?? '',
        backgroundColor: Colors.red[200],
        colorText: Colors.white
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
        ResponseApi? responseApi = await _usersProvider.update(user);
        if ( responseApi?.success == true ) {
          GetStorage().write('user', responseApi?.data);
          Get.snackbar(responseApi?.message ?? '', '');
        } else {
          Get.snackbar(
            'Datos no válidos',
            responseApi?.message ?? '',
            backgroundColor: Colors.red[200],
            colorText: Colors.white
          );
        }
      } else {

        Stream? stream = await _usersProvider.updateWithImage(user, imageFile!);

        stream?.listen((res) {
          ResponseApi? responseApi = ResponseApi.fromJson(json.decode(res));
          
          if (responseApi.success == true) {
            GetStorage().write('user', responseApi.data);
            Get.snackbar( 'Actualización finalizada' ,responseApi.message ?? '');
          } else {
            Get.snackbar(
              'Datos no válidos',
              responseApi.message ?? '',
              backgroundColor: Colors.red[200],
              colorText: Colors.white
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

    Widget cancelButton = ElevatedButton(
      onPressed: () {
        Get.back();
      },
      child: const Text('Cancelar')
    );

    Widget confirmButton = ElevatedButton(
      onPressed: () {
        isEnable2.value = false;
        deleteAccount();
      },
      child: const Text('Confirmar')
    );

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('¿Estás seguro que quieres eliminar la cuenta?'),
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
    Widget galleryButton = ElevatedButton(
      // style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(const Color(0xFF303F9F)) ),
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery);
      },
      child: const Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
      onPressed: () {
        selectImage(ImageSource.camera);
      },
      child: const Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Selecciona tu imagen'),
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