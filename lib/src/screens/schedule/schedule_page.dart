import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:agenda_app/src/screens/schedule/schedule_controller.dart';
import 'package:agenda_app/src/screens/clase/detail/clase_detail_controller.dart';

import 'package:agenda_app/src/models/clase.dart';

class SchedulePage extends StatelessWidget {
  final ScheduleController _scheduleController =
      Get.put(ScheduleController()); //para buscar las clases
  var id = "6";

  late Clase? id_subject; //para asignarlos a cada una de las horas del schedule
  late Clase? begin_hour;
  late Clase? end_hour;
  late Clase? days;
  late Clase? classroom;
  late Clase? building;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mi horario"),
        ),
        body: SfCalendar(
          view: CalendarView.week,
          dataSource: MeetingDataSource(_getDataSource()),
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ));
  }

  List<Meeting> _getDataSource() {
    Future<List<Clase?>> clases = _scheduleController.getClasesByUser(id); //aqui obtenemos la lista de los datos
    print(clases);
    // int size = clases.length;


    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));


    // for (Clase clase in clases.){

    // }

    meetings.add(Meeting('Conference', startTime, endTime,
        AppColors.colors.inversePrimary, false));
    return meetings; // 01/01/01 07:00:00   -> 01/01/23  begin_hour + :00
    // 01/01/01 07:00:00   -> 01/01/23  end_hour + :00
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
