import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/subject/add_subject/add_subject_controller.dart';

class AddSubjectPage extends StatefulWidget {
  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  AddSubjectController addSubjectController = Get.put(AddSubjectController());

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
            controller: addSubjectController.nameClassController, ////<----
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
            controller: addSubjectController.codeClassController,
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
            controller: addSubjectController.profesorClassController,
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
      child: MaterialButton(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15) ),
        disabledColor: Colors.grey,
        color: AppColors.colors.secondaryContainer,
        child: Container(
          padding: const EdgeInsets.symmetric( horizontal: 30, vertical: 15 ),
          child: const Text(
            'Registrar Materia',
          ),
        ),
        onPressed: () {
          addSubjectController.register(context);
        },
      ),
    );
  }
} //Fin Class
