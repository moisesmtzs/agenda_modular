import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';

class SubjectController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final SubjectProvider _subjectProvider = SubjectProvider();

  void goToAddSubject() {
    Get.toNamed('/addSubject');
  }

  Future<List<Subject?>> getSubjects() async {
    return await _subjectProvider.findByUser(userSession.id ?? '0');
  }
}
