import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:agenda_app/src/models/clase.dart';

class ScheduleController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  final ClaseProvider _claseProvider = ClaseProvider();

  List<List<String>> clases = [];

  Future<List<Clase?>> getClasesByUser(String idSubject) async {
    return await _claseProvider.findByUser(userSession.id ?? '0');
  }

  Future<List> main() async {
    List<Clase?> listaDeClases =
        await _claseProvider.findByUser(userSession.id ?? '0');
    for (int i = 0; i < listaDeClases.length; i++) {
      clases.add([
        listaDeClases[i]!.id_subject.toString(),
        listaDeClases[i]!.begin_hour.toString(),
        listaDeClases[i]!.end_hour.toString(),
        listaDeClases[i]!.days.toString()
      ]);
      dayOfWeek(
          listaDeClases[i]!.days.toString()); //para extraer la fecha ideonia
    }
    return clases;
  }

  int dayOfWeek(String day) {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;
    // print("Day of week: ${dayOfWeek}");
    // print("DAY: ${day}");
    //para saber que dia de la semana es
    if (day == "lunes" && dayOfWeek == 1) {
      print("lunes");
    }
    if (day == "martes" && dayOfWeek == 2) {
      print("martes");
    }
    if (day == "miercoles" && dayOfWeek == 3) {
      print("miercoles");
    }
    if (day == "jueves" && dayOfWeek == 4) {
      print("jueves");
    }
    if (day == "viernes" && dayOfWeek == 5) {
      print("viernes");
    }
    if (day == "sabado" && dayOfWeek == 6) {
      print("sabado");
    }
    if (day == "domingo" && dayOfWeek == 7) {
      print("domingo");
    }
    return 0;
  }

  void selectedDayWeek(int num) {
    print('Hoy es el día $dayOfWeek');
  }
}
