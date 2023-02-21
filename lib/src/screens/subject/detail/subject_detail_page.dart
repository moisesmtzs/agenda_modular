import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/screens/subject/detail/subject_detail_controller.dart';
import 'package:agenda_app/src/screens/subject/update/subject_update_page.dart';

import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/screens/clase/detail/clase_detail_controller.dart';
import 'package:agenda_app/src/screens/clase/update/clase_update_page.dart';

import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:agenda_app/src/widgets/no_subject_widget.dart';

class SubjectDetailPage extends StatelessWidget {
  final SubjectDetailController _subjectDetailController =
      Get.put(SubjectDetailController());

  late Subject? subject;
  late Subject? code;
  late Subject? profesor;

  SubjectDetailPage({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _datesSubject(context),
          _listclass(context),
        ],
      ),
    );
  }

  Widget _datesSubject(BuildContext context) {
    //Mostramos los datos de la materia con la opcion de editar
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      margin: const EdgeInsets.only(top: 20, bottom: 40, left: 30, right: 30),
      child: ListView(physics: const ClampingScrollPhysics(), children: [
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
                        topRight: Radius.circular(10.0)),
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
        const SizedBox(height: 40),
        Text(
          subject?.subject_code ?? '',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          subject?.professor_name ?? '',
          style: const TextStyle(fontSize: 16),
        ),
      ]),
    );
  }

  Widget _listclass(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _subjectDetailController.getClasesBySubject(),
          builder: (context, AsyncSnapshot<List<Clase?>> snapshot) {
            if (snapshot.hasData) {
              //preguntamos si viene informacion
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (_, index) {
                      return _claseCard(snapshot.data![index]!, context);
                    });
              } else {
                return NoSubjectWidget(text: 'No hay Clases agregadas');
              }
            } else {
              return NoSubjectWidget(text: 'No hay Clases agregadas');
            }
          }),
    );
  }

  Widget _claseCard(Clase? clase, BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.bottomSheet(
            ClaseUpdatePage(clase: clase),
            enableDrag: false,
            backgroundColor: AppColors.colors.secondaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
            ),
          );
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 30),
              width: double.infinity,
              height: 100,
              decoration: _cardBorders(),
            )));
  }

  Widget _claseText(String subjectName) {
    //aqui tengo que mostrar los detalle de la clase
    return SizedBox(
        width: 350,
        child: Container(
            margin: const EdgeInsets.only(right: 25),
            child: Text(
              (subjectName != '')
                  ? subjectName
                  : "Sin nombre a clase asignado", //modificar esto
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )));
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


// class SubjectDetailPage extends StatelessWidget {
//   SubjectDetailController subjectDetailController =
//       Get.put(SubjectDetailController());

//   late Subject? subject;
//   late Subject? code;
//   late Subject? profesor;

//   SubjectDetailPage({Key? key, required this.subject}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 1,
//       margin: const EdgeInsets.only(top: 20, bottom: 40, left: 30, right: 30),
//       child: ListView(physics: const ClampingScrollPhysics(), children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit_outlined, size: 30),
//               color: AppColors.colors.primary,
//               onPressed: () {
//                 Get.bottomSheet(
//                   SubjectUpdatePage(subject: subject),
//                   enableDrag: true,
//                   isDismissible: true,
//                   isScrollControlled: true,
//                   ignoreSafeArea: false,
//                   backgroundColor: AppColors.colors.secondaryContainer,
//                   barrierColor: Colors.black.withOpacity(0),
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10.0),
//                         topRight: Radius.circular(10.0)),
//                   ),
//                 );
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete_outline_rounded, size: 30),
//               color: AppColors.colors.primary,
//               onPressed: () {
//                 subjectDetailController.confirmationDialog(
//                     context, subject?.id ?? '0');
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Text(
//           subject?.name ?? '',
//           style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 40),
//         Text(
//           subject?.subject_code ?? '',
//           style: const TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           subject?.professor_name ?? '',
//           style: const TextStyle(fontSize: 16),
//         ),
//       ]),
//     );
//   }
// }
