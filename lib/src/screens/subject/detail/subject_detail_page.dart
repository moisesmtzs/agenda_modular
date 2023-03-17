import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/screens/subject/detail/subject_detail_controller.dart';
import 'package:agenda_app/src/screens/subject/update/subject_update_page.dart';

import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/screens/clase/detail/clase_detail_controller.dart';
import 'package:agenda_app/src/screens/clase/update/clase_update_page.dart';
import 'package:agenda_app/src/screens/clase/detail/clase_detail_page.dart';


import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:agenda_app/src/widgets/no_subject_widget.dart';

class SubjectDetailPage extends StatelessWidget {

  final SubjectDetailController _subjectDetailController = Get.put(SubjectDetailController());

  final ClaseDetailController _claseDetailController = Get.put(ClaseDetailController());

  late Subject? subject;
  late Subject? code;
  late Subject? profesor;

  late Clase? clase;

  late Clase? begin_hour;

  SubjectDetailPage({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _datesSubject(context);
  }

  Widget _datesSubject(BuildContext context) {
    late var idSubject = subject?.id ?? '';
    late var professor = subject?.professor_name ?? '';
    late var code = subject?.subject_code ?? '';
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 30),
                color: AppColors.colors.primary,
                onPressed: () {
                  Get.bottomSheet(
                    SubjectUpdatePage(subject: subject),
                    enableDrag: true,
                    isDismissible: true,
                    isScrollControlled: true,
                    ignoreSafeArea: false,
                    backgroundColor: AppColors.colors.secondaryContainer,
                    barrierColor: Colors.black.withOpacity(0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 30),
                color: AppColors.colors.primary,
                onPressed: () {
                  _subjectDetailController.confirmationDialog(
                      context, subject?.id ?? '0');
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subject?.name ?? '',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            (subject?.subject_code != '')
                ? 'Codigo: $code'
                : "Sin codigo asignada",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            (subject?.professor_name != '')
                ? 'Profesor: $professor'
                : "Sin profesor asignada",
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Clases" , 
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: AppColors.colors.primary,
                onPressed: () => _subjectDetailController.goToClase(),
              ),
            ],
            
          ),
          _listclass(context, idSubject),
        ],
      ),
    );
  }



  Widget _listclass(BuildContext context, idSubject) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: FutureBuilder(
        future: _subjectDetailController.getClasesBySubject(idSubject),//OCUPO PASARLE EL ID DE CUANDO LO TOQUE
        builder: (context, AsyncSnapshot<List<Clase?>> snapshot) {
          if (snapshot.hasData) {
            //preguntamos si viene informacion
            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (_, index) {
                  return _claseCard(snapshot.data![index]!, context);
                }
              );
            } else {
              return NoSubjectWidget(text: 'No hay clases agregadas');
            }
          } else {
            return NoSubjectWidget(text: 'No hay clases agregadas');
          }
        },
      ),
    );
  }
//justoooo aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
  Widget _claseCard(Clase? clase, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          ClaseDetailPage(clase: clase),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: double.infinity,
            height: 100,
            decoration: _cardBorders(),
            child: Stack(
              alignment: Alignment.topLeft, 
              children: [
                Positioned(left: 15, child: _claseText(clase,context)),
              ]
            )
          )
      )
    );
  }

  Widget _claseText(Clase? clase,BuildContext context) {
    late var beginHour = DateFormat("HH:mm").format(DateTime.parse(clase?.begin_hour ?? ''));
    late var endHour = DateFormat("HH:mm").format(DateTime.parse(clase?.end_hour ?? ''));
    late var day = clase?.days;
    late var classroom = clase?.classroom;
    late var building = clase?.building;

    return Column(

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            // children: [
            //   IconButton(
            //         icon: const Icon(Icons.edit_outlined, size: 30),
            //         color: AppColors.colors.primary,
            //         onPressed: () {
            //           Get.bottomSheet(
            //             ClaseUpdatePage(clase: clase),
            //             enableDrag: true,
            //             isDismissible: true,
            //             isScrollControlled: true,
            //             ignoreSafeArea: false,
            //             backgroundColor: AppColors.colors.secondaryContainer,
            //             barrierColor: Colors.black.withOpacity(0),
            //             shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.only(
            //                   topLeft: Radius.circular(10.0),
            //                   topRight: Radius.circular(10.0)),
            //             ),
            //           );
            //         },
            //       ),
            //   IconButton(
            //     icon: const Icon(Icons.delete_outline_rounded, size: 30),
            //     color: AppColors.colors.primary,
            //     onPressed: () {
            //       _claseDetailController.confirmationDialog(
            //           context, clase?.id ?? '0');
            //     },
            //   ),
            // ],
          ),
              
          Column(
            children:[
              
              const SizedBox(height: 10),
              Text(
                (clase?.days != '')? 'Dia: $day' : '',
              ),
              Row(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    (clase?.begin_hour != '')? 'Horario: $beginHour' : '',
                    
                  ),
                  Text(
                    (clase?.end_hour != '')? '- $endHour' : '',
                    
                  ),
                ]
              ),

              Row(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    (clase?.classroom != '')? 'Salon: $building' : '',
                    
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (clase?.building != '')? '$classroom' : '',
                    
                  ),
                ]
              ),
            ]
          ),
        ],
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: AppColors.colors.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 6),
              blurRadius: 10,
            )
          ]);
}