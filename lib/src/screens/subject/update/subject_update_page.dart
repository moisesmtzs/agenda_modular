import 'package:agenda_app/src/screens/subject/update/subject_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class SubjectUpdatePage extends StatelessWidget {
  SubjectUpdatePage({Key? key, required this.subject}) : super(key: key);

  late Subject? subject;
  late SubjectUpdateController subjectUpdateController =
      Get.put(SubjectUpdateController(subject!));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListView(
          physics: const ClampingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.check_rounded,
                  size: 30, color: AppColors.colors.onPrimary),
              label: Text('Actualizar Materia',
                  style: TextStyle(
                      fontSize: 20, color: AppColors.colors.onPrimary)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.colors.primary),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              onPressed: () {
                subjectUpdateController.updateSubject(context);
              },
            ),
            const SizedBox(height: 25),
            _subjectName(),
            const SizedBox(height: 20),
            _subjectCode(),
            const SizedBox(height: 20),
            _subjectProfessor(),
          ]),
    );
  }

  Widget _subjectName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.inversePrimary,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
              controller: subjectUpdateController.nameController,
              cursorRadius: const Radius.circular(8.0),
              maxLength: 180,
              decoration: const InputDecoration(
                  hintText: "Matematicas",
                  labelText: "Nombre de la materia",
                  suffixIcon: Icon(Icons.perm_identity_sharp)),
              validator: (value) {
                String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                RegExp nameregExp = RegExp(pattern);
                return nameregExp.hasMatch(value ?? '')
                    ? null
                    : 'Nombre no válido';
              })
        ]),
      ),
    );
  }

  Widget _subjectCode() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.inversePrimary,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
              controller: subjectUpdateController.codeController,
              maxLines: 3,
              maxLength: 255,
              textAlign: TextAlign.justify,
              cursorRadius: const Radius.circular(8.0),
              decoration: const InputDecoration(
                  hintText: "7033",
                  labelText: "Codigo Materia",
                  suffixIcon: Icon(Icons.numbers)),
              validator: (value) {
                String pattern = r"\b[0-9]";
                RegExp nameregExp = RegExp(pattern);
                return nameregExp.hasMatch(value ?? '')
                    ? null
                    : 'Codigo no válida';
              })
        ]),
      ),
    );
  }

  Widget _subjectProfessor() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.inversePrimary,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
              controller: subjectUpdateController.professorController,
              cursorRadius: const Radius.circular(8.0),
              maxLength: 180,
              decoration: const InputDecoration(
                  hintText: "Fabiola",
                  labelText: "Nombre Profesor",
                  suffixIcon: Icon(Icons.perm_identity_sharp)),
              validator: (value) {
                String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                RegExp nameregExp = RegExp(pattern);
                return nameregExp.hasMatch(value ?? '')
                    ? null
                    : 'Nombre no válido';
              })
        ]),
      ),
    );
  }
}
