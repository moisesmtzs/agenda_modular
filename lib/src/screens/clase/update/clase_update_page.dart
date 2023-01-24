import 'package:agenda_app/src/screens/clase/update/clase_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

enum SingingCharacter { lunes, martes, miercoles, jueves, viernes, sabado }

List<String> items = <String>[
  "07:00",
  "08:00",
  "09:00",
  "10:00",
  "11:00",
  "12:00",
  "13:00",
  "14:00",
  "15:00",
  "16:00",
  "17:00",
  "18:00",
  "19:00",
  "20:00",
  "21:00",
  "22:00"
];

// class ClaseUpdatePage extends StatefulWidget {
//   @override
//   State<ClaseUpdatePage> createState() => _ClaseUpdatePageState();
// }

// class _ClaseUpdatePageState extends State<ClaseUpdatePage> {
//   _ClaseUpdatePageState({Key? key, required this.clase}) : super(key: key);

class ClaseUpdatePage extends StatelessWidget {
  ClaseUpdatePage({Key? key, required this.clase}) : super(key: key);

  late Clase? clase;
  late ClaseUpdateController claseUpdateController =
      Get.put(ClaseUpdateController(clase!));

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
              label: Text('Actualizar Clase',
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
                claseUpdateController.updateClase(context);
              },
            ),
            const SizedBox(height: 25),
            _claseDay(),
            const SizedBox(height: 20),
            _claseBegin(),
            const SizedBox(height: 20),
            _claseEnd(),
            const SizedBox(height: 20),
            _claseClasroom(),
            const SizedBox(height: 20),
            _claseBuilding(),
          ]),
    );
  }

  SingingCharacter? _character = SingingCharacter.lunes;
  Widget _claseDay() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('lunes'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.lunes,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseUpdateController.daysController = 'lunes';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('martes'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.martes,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseUpdateController.daysController = 'martes';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('miercoles'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.miercoles,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseUpdateController.daysController = 'miercoles';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('jueves'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.jueves,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseUpdateController.daysController = 'jueves';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('viernes'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.viernes,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseUpdateController.daysController = 'viernes';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('sabado'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.sabado,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseUpdateController.daysController = 'sabado';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _claseBegin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 30,
        hint: const Text("Hora de Inicio"),
        value: claseUpdateController.begineController,
        items: items
            .map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            claseUpdateController.begineController = option.toString();
          });
        },
      ),
    );
  }

  Widget _claseEnd() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 30,
        hint: const Text("Hora de Fin"),
        value: claseUpdateController.endController,
        items: items
            .map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            claseUpdateController.endController = option.toString();
          });
        },
      ),
    );
  }

  Widget _claseClasroom() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: claseUpdateController.clasroomController,
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: "8",
                labelText: "Numero de Salon",
                prefixIcon: Icon(Icons.numbers)),
            validator: (value) {
              String pattern = r"\b[0-9]";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Nombre no válido';
            }),
      ),
    );
  }

  Widget _claseBuilding() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: claseUpdateController.buildingController,
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                hintText: "A",
                labelText: "Edificio",
                prefixIcon: Icon(Icons.abc)),
            validator: (value) {
              String pattern = r"\b[a-zA-Z]";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Nombre no válido';
            }),
      ),
    );
  }
}
