import 'package:agenda_app/src/screens/subject/detail/subject_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/screens/subject/detail/subject_detail_controller.dart';
import 'package:agenda_app/src/screens/subject/update/subject_update_page.dart';
import 'package:agenda_app/src/screens/subject/subject_controller.dart';
import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:agenda_app/src/widgets/no_subject_widget.dart';

class SubjectPage extends StatelessWidget {
  
  final SubjectController _subjectController = Get.put(SubjectController());

  Future<void> _refresh() async{
    await _subjectController.getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Materias',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: FutureBuilder(
        future: _subjectController.getSubjects(),
        builder: (context, AsyncSnapshot<List<Subject?>> snapshot) {
          if (snapshot.hasData) {
            //preguntamos si viene informacion
            if (snapshot.data!.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (_, index) {
                    return _subjectCard(snapshot.data![index]!, context);
                  }
                ),
              );

            } else {
              return Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: NoSubjectWidget(text: 'No hay materias agregadas')
                )
              );
            }
          } else {
              return Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: NoSubjectWidget(text: 'No hay materias agregadas')
                )
              );
          }
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar Materia'),
        onPressed: () => _subjectController.goToAddSubject(),
        icon: const Icon(Icons.add_circle),
      ),
    );
  }

  Widget _subjectCard(Subject? subject, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          SubjectDetailPage(subject: subject),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          decoration: _cardBorders(),
          child: _subjectText(subject?.name ?? '')
        )
      )
    );
  }

  Widget _subjectText(String subjectName) {
    return FittedBox(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          (subjectName != '')
              ? subjectName
              : "Sin nombre a materia asignado",
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.colors.onPrimary,
          ),
        )
      )
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: AppColors.colors.primary,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 6),
        blurRadius: 10,
      )
    ]
  );
}