import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';

class TaskController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

}