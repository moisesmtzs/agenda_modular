import 'dart:math';

import 'package:agenda_app/main.dart';
import 'package:agenda_app/src/screens/clase/detail/clase_detail_page.dart';
import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:agenda_app/src/screens/schedule/schedule_controller.dart';
import 'package:agenda_app/src/screens/clase/detail/clase_detail_controller.dart';

import 'package:agenda_app/src/models/clase.dart';
import '../../widgets/no_schedule_widget.dart';
import '../../widgets/no_task_widget.dart';

class SchedulePage extends StatelessWidget {
  final ScheduleController _scheduleController = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Horario'),
      ),
      body: FutureBuilder(
          future: _getDataSource(),
          builder: (context, AsyncSnapshot<List<Meeting>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return SfCalendar(
                  view: CalendarView.week,
                  onTap: (CalendarTapDetails details) async {
                    _scheduleController.dia = details.date;
                    _scheduleController.fecha = DateTime(0001, 01, 01, _scheduleController.dia!.hour, _scheduleController.dia!.minute);
                    print(_scheduleController.fecha.toString());
                    Clase? clasePrueba = await _scheduleController.getClasesByIdDaysBegin();
                    Get.bottomSheet(
                      ClaseDetailPage(clase: clasePrueba),
                      enableDrag: true,
                      isDismissible: true,
                      isScrollControlled: true,
                      ignoreSafeArea: true,
                      backgroundColor: AppColors.colors.secondaryContainer,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)
                        ),
                      ),
                    );
                  },
                  timeSlotViewSettings: const TimeSlotViewSettings(dateFormat: 'd', dayFormat: 'EEE'),
                  showWeekNumber: false,
                  selectionDecoration: const BoxDecoration(color: Colors.transparent),
                  dataSource: MeetingDataSource(snapshot.data),
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
                  ),
                );
              } else {
                return Center(child: NoScheduleWidget(text: 'No hay horario'));
              }
            } else {
              return Center(child: NoScheduleWidget(text: 'Cargando horario'));
            }
          }),
    );
  }

  Future<List<Meeting>> _getDataSource() async {
    List<Meeting> meetings = await _scheduleController.main();
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting>? source) {
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
  String? getRecurrenceRule(int index) {
    return _getMeetingData(index).recurrenceRule;
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

class Meeting {
  Meeting(
    this.eventName, 
    this.from, 
    this.to, 
    this.background, 
    this.isAllDay,
    this.recurrenceRule
  );

  String eventName;

  DateTime from;

  DateTime to;

  Color background;

  bool isAllDay;

  String recurrenceRule;
}
