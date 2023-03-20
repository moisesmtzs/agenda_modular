import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/screens/schedule/schedule_page.dart';

import '../../models/subject.dart';
import '../../ui/app_colors.dart';

class ScheduleController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  final ClaseProvider _claseProvider = ClaseProvider();
  final SubjectProvider _subjectProvider = SubjectProvider();

  List<List<String>> clases = [];
  List<Meeting> clasesVista = [];

  Future<List<Clase?>> getClasesByUser(String idSubject) async {
    return await _claseProvider.findByUser(userSession.id ?? '0');
  }

  Future<List<Meeting>> main() async {
    //LISTA DE CLASES A MOSTRAR//
    List<Meeting> meetings = [];
    //RECUPERA LAS CLASES//
    List<Clase?> listaDeClases = await _claseProvider.findByUser(userSession.id ?? '0');
    for (int i = 0; i < listaDeClases.length; i++) {
      //GUARDAMOS LA CLASE//
      clases.add([
        listaDeClases[i]!.id_subject.toString(),
        listaDeClases[i]!.begin_hour.toString(),
        listaDeClases[i]!.end_hour.toString(),
        listaDeClases[i]!.days.toString()
      ]);
      DateTime begin_hour = DateTime.parse(listaDeClases[i]!.begin_hour.toString());
      DateTime end_hour = DateTime.parse(listaDeClases[i]!.end_hour.toString());
      print(begin_hour.toString());
      print(end_hour.toString());
      //OBTENER DIA//
      String sDay = listaDeClases[i]!.days.toString();
      if(sDay.toLowerCase() == 'lunes') sDay = "MO";
      else if(sDay.toLowerCase() == 'martes') sDay = "TU";
      else if(sDay.toLowerCase() == 'miercoles') sDay = "WE";
      else if(sDay.toLowerCase() == 'jueves') sDay = "TH";
      else if(sDay.toLowerCase() == 'viernes') sDay = "FR";
      else if(sDay.toLowerCase() == 'sabado') sDay = "SA";
      else if(sDay.toLowerCase() == 'domingo') sDay = "SU";
      //GENERAR RECUADRO//
      Meeting claseView = Meeting('HOLA',
                                  DateTime(DateTime.now().year, 01, 01, begin_hour.hour),
                                  DateTime(DateTime.now().year, 01, 01, begin_hour.hour+2),
                                  AppColors.colors.inversePrimary,
                                  false,
                                  'FREQ=WEEKLY;INTERVAL=1;BYDAY='+sDay+';COUNT=52');
      meetings.add(claseView);
    }
    return meetings;
  }
}
