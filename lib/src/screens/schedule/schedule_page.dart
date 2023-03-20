import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:agenda_app/src/screens/schedule/schedule_controller.dart';
import 'package:agenda_app/src/screens/clase/detail/clase_detail_controller.dart';

import 'package:agenda_app/src/models/clase.dart';

import '../../widgets/no_task_widget.dart';

class SchedulePage extends StatelessWidget {
  final ScheduleController _scheduleController = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDataSource(),
        builder: (context, AsyncSnapshot<List<Meeting>> snapshot) 
        {
          if (snapshot.hasData) {
            if ( snapshot.data!.isNotEmpty ) {
              SfCalendar(
                  view: CalendarView.week,
                  timeZone: 'Pacific Standard Time (Mexico)',
                  timeSlotViewSettings:
                    TimeSlotViewSettings(dateFormat: 'd', dayFormat: 'EEE'),
                  showWeekNumber: false,
                  selectionDecoration: BoxDecoration(color: Colors.transparent),
                  dataSource: MeetingDataSource(snapshot.data),
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
              );
            } else {
              return NoTaskWidget(text: 'No hay tareas agregadas');
            }
          } else {
            return NoTaskWidget(text: 'No hay tareas agregadas');
          }
      }
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

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.recurrenceRule);

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

  /// Para repetir todas las semanas la misma clase [Appointment].
  String recurrenceRule;
}
