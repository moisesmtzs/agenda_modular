import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';

//SQLITE//
import 'package:agenda_app/src/api/db.dart';

import '../../models/connectivity.dart';

class SubjectController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final SubjectProvider _subjectProvider = SubjectProvider();

  Connect connectivity = Connect();

  SubjectController()
  {
    connectivity.getConnectivity();
  }

  void goToAddSubject() {
    Get.toNamed('/addSubject');
  }

  Future<List<Subject?>> getSubjects() async {
    if(connectivity.isConnected == true)
    {
      return await _subjectProvider.findByUser(userSession.id ?? '0');
    }
    else
    {
      return await db.getSubjects();
    }  
  }
}
