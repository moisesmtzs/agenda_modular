import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';

//SQLITE//
import 'package:agenda_app/src/api/db.dart';

class SubjectController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  final SubjectProvider _subjectProvider = SubjectProvider();
  
  SubjectController()
  {
    GetConnectivity();
  }

  //VERIFICAR CONEXION A INTERNET//
  bool isConnect = false; 
  void GetConnectivity() async
  {
    try { 
      final result = await InternetAddress.lookup('google.com'); 
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) 
      { 
        print('CONECTADO'); 
        isConnect = true;
      }
    } on SocketException catch (_) { 
        print('SIN CONEXION'); 
        isConnect = false;
    }  
  }

  void goToAddSubject() {
    Get.toNamed('/addSubject');
  }

  Future<List<Subject?>> getSubjects() async {
    if(isConnect == true)
    {
      return await _subjectProvider.findByUser(userSession.id ?? '0');
    }
    else
    {
      return await db.selectSubject();
    }  
  }
}
