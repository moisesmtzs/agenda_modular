import 'package:flutter/material.dart';
import "dart:io";

import 'package:get/get.dart';

import 'package:agenda_app/src/widgets/auth_background.dart';
import 'package:agenda_app/src/widgets/card_container.dart';
import 'package:agenda_app/src/ui/input_decoration.dart';
import 'package:agenda_app/src/screens/subject/subject_controller.dart';

import 'package:agenda_app/src/screens/screens.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class SubjectPage extends StatefulWidget {
  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  SubjectController subjectController = Get.put(SubjectController());

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear materia',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _textName(),
          _textCodeSubject(),
          _textProfesorsName(),
        ],
      ),
      bottomNavigationBar: _registerButton(),
    );
  }

  Widget _textName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: subjectController.nameClassController, ////<----
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                hintText: "Matematicas",
                labelText: "Nombre Materia",
                prefixIcon: Icon(Icons.perm_identity_sharp)),
            validator: (value) {
              String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Nombre no válido';
            }),
      ),
    );
  }

  Widget _textCodeSubject() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: subjectController.codeClassController,
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: "5909",
                labelText: "Codigo Materia",
                prefixIcon: Icon(Icons.numbers)),
            validator: (value) {
              String pattern = r"\b[0-9]";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Codigo no válido';
            }),
      ),
    );
  }

  Widget _textProfesorsName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: subjectController.profesorClassController,
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                hintText: "Marcos",
                labelText: "Nombre Profesor",
                prefixIcon: Icon(Icons.perm_identity_sharp)),
            validator: (value) {
              String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Nombre no válido';
            }),
      ),
    );
  }

  //-------------------------------------------------------------------------------
  Widget _registerButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          subjectController.register(context);
        },
        child: const Text(
          'Registrar Materia',
        ),
      ),
    );
  }
} //Fin Class
