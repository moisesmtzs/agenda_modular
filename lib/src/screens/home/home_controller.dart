import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';

class HomeController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  // HomeController() {

  // }

  void goToUpdatePage() {

    Get.toNamed('/updateProfile');

  }

  void logOut() {

    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);

  }

}