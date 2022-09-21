import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/tasks/add_task/add_task_controller.dart';
import 'package:agenda_app/src/ui/input_decoration.dart';

class AddTaskPage extends StatelessWidget{
  
  final AddTaskController _controller = Get.put(AddTaskController());

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'openAddTaskPage',
      child: Scaffold(
        // backgroundColor: Colors.indigo.shade300,
        appBar: AppBar(
          title: const Text('Agregar tarea'),
          backgroundColor: Colors.indigo.shade300,
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder( borderRadius: BorderRadius.circular(30) ),
            null,
            0
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const SizedBox(height: 20),
            _taskName(),
            const SizedBox(height: 20),
            _taskDesc(),
            const SizedBox(height: 20),
            _taskDate(context),
            const SizedBox(height: 20),
            _taskSubject(),
            const SizedBox(height: 20),
            _taskType(),
            const SizedBox(height: 20),
          ]
        ),
        bottomNavigationBar: _createTaskButton(context),
      ),
    );
  }

  Widget _taskName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              // controller: _con.nameController,
              cursorRadius: const Radius.circular(8.0),
              maxLength: 180,
              decoration: InputDecorations.authInputDecoration(
                hintText: "Hacer maqueta",
                labelText: "Nombre de la tarea",
                suffixIcon: Icons.task_outlined
              ),
              validator: ( value ){
                String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                RegExp nameregExp  = RegExp(pattern);
                return nameregExp.hasMatch( value ?? '' ) 
                  ? null 
                  : 'Nombre no válido';
              }
            )
          ]
        ),
      ),
    );
    
  }

  Widget _taskDesc() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              // controller: _con.descController,
              maxLines: 3,
              maxLength: 255,
              textAlign: TextAlign.justify,
              cursorRadius: const Radius.circular(8.0),
              decoration: InputDecorations.authInputDecoration(
                hintText: "Maqueta de 25x25",
                labelText: "Descripción de la tarea",
                suffixIcon: Icons.description_outlined
              ),
              validator: ( value ){
                String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                RegExp nameregExp  = RegExp(pattern);
                return nameregExp.hasMatch( value ?? '' ) 
                  ? null 
                  : 'Descripción no válida';
              }
            )
          ]
        ),
      ),
    );
    
  }  

  Widget _taskDate(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15) 
      ),
      child: Obx( () =>
        ListTile(
          title: Text('Fecha de entrega', style: TextStyle( color: Colors.indigo[300], fontSize: 18 ),),
          subtitle: Text(_controller.convertDateTimeDisplay(_controller.value.value), style: TextStyle( color: Colors.indigo[300] ),),
          trailing: Icon( Icons.date_range_outlined, color: Colors.indigo.shade300 ),
          onTap: () {
            _controller.showDatePick(context);
          },
        ),
      )
    );
  }

  Widget _taskSubject() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              // controller: _con.descController,
              maxLines: 3,
              maxLength: 255,
              textAlign: TextAlign.justify,
              cursorRadius: const Radius.circular(8.0),
              decoration: InputDecorations.authInputDecoration(
                hintText: "Introducción a la computación",
                labelText: "Materia",
                suffixIcon: Icons.description_outlined
              ),
              validator: ( value ){
                String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                RegExp nameregExp  = RegExp(pattern);
                return nameregExp.hasMatch( value ?? '' ) 
                  ? null 
                  : 'Tema no válido';
              }
            )
          ]
        ),
      ),
    );
    
  } 

  Widget _taskType() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              // controller: _con.descController,
              maxLines: 3,
              maxLength: 255,
              textAlign: TextAlign.justify,
              cursorRadius: const Radius.circular(8.0),
              decoration: InputDecorations.authInputDecoration(
                hintText: "Examen",
                labelText: "Tipo",
                suffixIcon: Icons.description_outlined
              ),
              validator: ( value ){
                String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                RegExp nameregExp  = RegExp(pattern);
                return nameregExp.hasMatch( value ?? '' ) 
                  ? null 
                  : 'Tipo no válido';
              }
            )
          ]
        ),
      ),
    );
    
  } 

  Widget _createTaskButton(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric( horizontal: 50, vertical: 20 ),
      child: MaterialButton(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15) ),
        disabledColor: Colors.grey,
        color: Colors.indigo[300],
        child: Container(
          padding: const EdgeInsets.symmetric( horizontal: 30, vertical: 15 ),
          child: const Text( 'Crear tarea', style: TextStyle( color: Colors.white ) )
        ),
        onPressed: () {
          _controller.register(context);
        },
      ),

    );

  }




}