import 'dart:async';
import 'dart:io';
//MODELOS//
import 'package:agenda_app/src/models/subject.dart';
import 'package:path_provider/path_provider.dart';
//SQLITE//
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class db
{
  //CONSTRUCTOR DE LA BASE DE DATOS//
  static Future<Database> openDB() async
  {
    return openDatabase(join(await getDatabasesPath(),'tot.db'),
      onCreate: (db, version)
      {
        return db.execute(
          "CREATE TABLE subject (id INTEGER PRIMARY KEY,id_user INTEGER,name TEXT,subject_code TEXT,professor_name TEXT,created_at TEXT,updated_at TEXT)"    
        );
      }, version: 1);
  }

  //---------------------------------------------------- <MATERIA> ----------------------------------------------------//
  //INSERT//
  static Future<int?> insertSubject(Subject newSubject) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO subject(id_user, name, subject_code, professor_name, created_at, updated_at) VALUES ( ${newSubject.id_user}, '${newSubject.name}', '${newSubject.subject_code}', '${newSubject.professor_name}', '${today}', '${today}')";
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);
    return result;
    //return database.insert('subject', newSubject.toLocalBD());
    //ALMACENAREMOS EL SQL EN UN ARCHIVO//

  }

  //OBTENER TODOS//
  static Future<List<Subject>> selectSubject() async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS TODOS LOS ELEMENTOS DE LA TABLA INDICADA//
    final List<Map<String, dynamic>> subjectList  = await database.query('subject');
    //RECORREMOS CADA ELEMENTO PARA CONSTRUIR EL OBJETO SUBJECT POR CADA UNO//
    return List.generate(subjectList.length, (i) => Subject(
      id: subjectList[i]['id'].toString(),
      id_user: subjectList[i]['id_user'].toString(),
      name: subjectList[i]['name'],
      subject_code: subjectList[i]['subject_code'],
      professor_name: subjectList[i]['professor_name'],
    ));
  }
  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <CLASE> -----------------------------------------------------//
  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <TAREA> -----------------------------------------------------//
  //-------------------------------------------------------------------------------------------------------------------//

}