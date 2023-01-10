import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';

class SubjectController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final SubjectProvider _tasksProvider = SubjectProvider();

  List<String> status = <String>['PENDIENTE', 'COMPLETADO'].obs;

  var isSelected = false.obs;
  var taskList = <Subject?>[].obs;

  void goToAddSubject() {
    Get.toNamed('/addSubject');
  }

  // Future<List<Subject?>> getTasks(String status) async {
  //   return await _tasksProvider.getByUserAndStatus(
  //       userSession.id ?? '0', status);
  // }
}
