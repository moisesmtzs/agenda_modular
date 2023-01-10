import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agenda_app/src/screens/clase/add_clase/add_clase_controller.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class ClasePage extends StatefulWidget {
  @override
  State<ClasePage> createState() => _ClasePageState();
}

enum SingingCharacter { lunes, martes, miercoles, jueves, viernes, sabado }

class _ClasePageState extends State<ClasePage> {
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

  //Controladores
  ClaseController claseController = Get.put(ClaseController());

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear una clase',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _day(),
          _begin(),
          _end(),
          _clasroom(),
          _building(),
        ],
      ),
      bottomNavigationBar: _registerButton(),
    );
  }

  Widget _begin() {
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
        value: claseController.begineController,
        items: items
            .map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            claseController.begineController = option.toString();
          });
        },
      ),
    );
  }

  Widget _end() {
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
        value: claseController.endController,
        items: items
            .map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            claseController.endController = option.toString();
          });
        },
      ),
    );
  }

  SingingCharacter? _character = SingingCharacter.lunes;
  Widget _day() {
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
                claseController.daysController = 'lunes';
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
                claseController.daysController = 'martes';
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
                claseController.daysController = 'miercoles';
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
                claseController.daysController = 'jueves';
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
                claseController.daysController = 'viernes';
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
                claseController.daysController = 'sabado';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _clasroom() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: claseController.clasroomController,
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

  Widget _building() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: claseController.buildingController,
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

  //-------------------------------------------------------------------------------
  Widget _registerButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          //claseController.daysController = finaldays;
          claseController.register(context);
        },
        child: const Text(
          'Registrar Materia',
        ),
      ),
    );
  }
} //Fin Class
