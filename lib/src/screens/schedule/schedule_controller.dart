import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:agenda_app/src/models/clase.dart';

class ScheduleController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  void goToClase() {
    Get.toNamed('/clase');
  }

  //Obtener las clases
  final ClaseProvider _claseProvider = ClaseProvider();

  Future<List<Clase?>> getClasesByUser(String idSubject) async {
    return await _claseProvider.findByUser(userSession.id ?? '0');
  }
}
