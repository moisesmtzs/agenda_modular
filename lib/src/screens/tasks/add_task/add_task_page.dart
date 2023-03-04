import 'package:agenda_app/src/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/tasks/add_task/add_task_controller.dart';

class AddTaskPage extends StatelessWidget{
  
  final AddTaskController _controller = Get.put(AddTaskController());

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'openAddTaskPage',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agregar tarea', style: TextStyle(fontSize: 24)),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder( borderRadius: BorderRadius.circular(30) ),
            null,
            0
          ),
        ),
        body: ListView(
          physics: const ClampingScrollPhysics(),
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
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _controller.nameController,
              cursorRadius: const Radius.circular(8.0),
              maxLength: 180,
              decoration: const InputDecoration(
                hintText: "Hacer maqueta",
                labelText: "Nombre de la tarea",
                suffixIcon: Icon(Icons.task_outlined)
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
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _controller.descriptionController,
              maxLines: 3,
              maxLength: 255,
              textAlign: TextAlign.justify,
              cursorRadius: const Radius.circular(8.0),
              decoration: const InputDecoration(
                hintText: "Maqueta de 25x25",
                labelText: "Descripción de la tarea",
                suffixIcon: Icon(Icons.description_outlined)
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
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15) 
      ),
      child: Obx( () =>
        ListTile(
          title: const Text('Fecha de entrega', style: TextStyle(  fontSize: 18 ),),
          subtitle: Text(_controller.convertDateTimeDisplay(_controller.value.value),),
          trailing: const Icon( Icons.date_range_outlined ),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Obx(() => DropdownButton(
        hint: const Text('Selecciona una materia'),
        isExpanded: true,
        dropdownColor: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        icon: const Visibility(visible: false, child: Icon(Icons.arrow_drop_down_circle_rounded)),
        underline: Container(
          alignment: Alignment.centerRight,
          child: const Icon(Icons.arrow_drop_down_circle),
        ),
        value: _controller.subjectSelected.value == '' ? null : _controller.subjectSelected.value,
        items: _dropDownSubjects(),
        onChanged: (String? value) {
          _controller.subjectSelected.value = value!;
        },
      ),)
    );
    
  } 

  Widget _taskType() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Obx(() => DropdownButton(
        hint: const Text('Tipo de tarea'),
        isExpanded: true,
        dropdownColor: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        icon: const Visibility(visible: false, child: Icon(Icons.arrow_drop_down_circle_rounded)),
        underline: Container(
          alignment: Alignment.centerRight,
          child: const Icon(Icons.arrow_drop_down_circle)
        ),
        value: _controller.typeSelected.value == '' ? null : _controller.typeSelected.value,
        items: _dropDownItems(_controller.typeList),
        onChanged: (String? value) {
          _controller.typeSelected.value = value!;
        },
      ),)
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
        color: AppColors.colors.secondaryContainer,
        child: Container(
          padding: const EdgeInsets.symmetric( horizontal: 30, vertical: 15 ),
          child: const Text('Crear tarea')
        ),
        onPressed: () {
          _controller.register(context);
        },
      ),

    );

  }

  List<DropdownMenuItem<String>> _dropDownItems(List<String> types) {
    List<DropdownMenuItem<String>> list = [];
    for (var type in types) {
      list.add(DropdownMenuItem(
        child: Text(type, style: TextStyle( color: AppColors.colors.onPrimaryContainer ),),
        value: type,
      ));
    }
    return list;
  }

  List<DropdownMenuItem<String>> _dropDownSubjects() {
    List<DropdownMenuItem<String>> list = [];
    for (var type in _controller.data) {
      list.add(DropdownMenuItem(
        child: Text(type!.name ?? '', style: TextStyle( color: AppColors.colors.onPrimaryContainer ),),
        value: type.name,
      ));
    }
    return list;
  } 

}