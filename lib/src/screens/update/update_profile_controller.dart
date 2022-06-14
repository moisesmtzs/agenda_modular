import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';

class UpdateProfileController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  void goToHomePage() {

    Get.offNamed('/home');

  }

}