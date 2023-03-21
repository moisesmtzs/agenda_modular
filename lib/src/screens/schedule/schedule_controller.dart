import 'dart:math';
import 'dart:ui';

import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/screens/schedule/schedule_page.dart';

import '../../models/connectivity.dart';
import '../../models/subject.dart';
import 'package:agenda_app/src/api/db.dart';

//http://192.168.31.247:3000/api/clase/findByIdDayBegine/6/martes/0001-01-01 08:00:00
class ScheduleController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  final ClaseProvider _claseProvider = ClaseProvider();
  final SubjectProvider _subjectProvider = SubjectProvider();

  List<List<String>> clases = [];
  List<Meeting> clasesVista = [];

  Connect connectivity = Connect();

  Clase? claseCalendario = Clase();
  DateTime? dia = DateTime(0001, 01, 01);
  DateTime fecha = DateTime(0001, 01, 01);

  Future<List<Clase?>> getClasesByUser(String idSubject) async {
    //GENERA REPLICA AL CREAR UN NUEVO REGISTRO//
    await connectivity.getConnectivityReplica();
    if(connectivity.isConnected == true)
    {
      return await _claseProvider.findByUser(userSession.id ?? '0');
    }
    else
    {
      return await db.getClases();
    }
    
  }

  //VALIDAR QUE EXISTE UNA CONEXION A INTERNET//
  Future validarInternet() async
  {
    await connectivity.getConnectivity();
  }

  Future getClasesByIdDaysBegin() async {//retornamos una clase

    List<String> dias = <String>[
      "lunes",//1
      "martes",
      "miercoles",
      "jueves",
      "viernes",
      "sabado",
      "domingo"
    ];

    claseCalendario = await _claseProvider.findByIdDayBegin(userSession.id ?? '0', dias[dia!.weekday-1], fecha.toString());
    
    return claseCalendario;
  }

  Future<List<Meeting>> main() async {
    //List<Clase?> clase = await _claseProvider.findByIdDayBegin(userSession.id ?? '0');
    //OBTENER COLOR//
    final Random random = Random();
    List<Color> colors = getColors();
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
      String idSub = listaDeClases[i]!.id_subject.toString();
      //OBTENER DIA//
      String sDay = listaDeClases[i]!.days.toString();
      if(sDay.toLowerCase() == 'lunes') sDay = "MO";
      else if(sDay.toLowerCase() == 'martes') sDay = "TU";
      else if(sDay.toLowerCase() == 'miercoles') sDay = "WE";
      else if(sDay.toLowerCase() == 'jueves') sDay = "TH";
      else if(sDay.toLowerCase() == 'viernes') sDay = "FR";
      else if(sDay.toLowerCase() == 'sabado') sDay = "SA";
      else if(sDay.toLowerCase() == 'domingo') sDay = "SU";
      int difHour = end_hour.hour-begin_hour.hour;
      int difMin = end_hour.minute-begin_hour.minute;

      //RECUPERAR NOMBRE//
      Subject? subj = await _subjectProvider.findById(idSub);

      //VALIDAR SI YA HAY UNA CLASE DE ESA MATERIA PARA PINTARLAS DEL MISMO COLOR//
      Color backgroundColor = Colors.white;
      for(int i = 0; i<meetings.length; i++)
      { 
        if(subj!.name == meetings[i].eventName)
        {
          backgroundColor = meetings[i].background;
        }
      }
      if(backgroundColor == Colors.white)
      {
        backgroundColor = colors[random.nextInt(colors.length-1)];
      }

      //GENERAR RECUADRO//
      Meeting claseView = Meeting(subj!.name ?? " ",
                                  DateTime(DateTime.now().year, 01, 01, begin_hour.hour),
                                  DateTime(DateTime.now().year, 01, 01, begin_hour.hour+difHour,begin_hour.minute+difMin),
                                  backgroundColor,
                                  false,
                                  'FREQ=WEEKLY;INTERVAL=1;BYDAY='+sDay+';COUNT=52');
      meetings.add(claseView);
    }
    return meetings;
  }
  List<Color> getColors()
  {
    final List<Color> colors = <Color>[];
    colors.add(const Color(0xFF0F8644));
    colors.add(const Color(0xFF8B1FA9));
    colors.add(const Color(0xFFD20100));
    colors.add(const Color(0xFFFC571D));
    colors.add(const Color(0xFF36B37B));
    colors.add(const Color(0xFF01A1EF));
    colors.add(const Color(0xFF3D4FB5));
    colors.add(const Color(0xFFE47C73));
    colors.add(const Color(0xFF636363));
    colors.add(const Color(0xFF0A8043));
    return colors;
  }
  
}
