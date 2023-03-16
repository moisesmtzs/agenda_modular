import 'dart:async';
import 'dart:io';
import 'package:agenda_app/src/models/query.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
//MODELOS//
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
//SQLITE//
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//PROVIDERS//
import '../models/connectivity.dart';
import '../providers/subjectProvider.dart';
import '../providers/syncProvider.dart';
import '../providers/tasksProvider.dart';

class db
{
  //PROVIDERS//
  TasksProvider tasksProvider = TasksProvider();
  SubjectProvider subjectProvider = SubjectProvider();

  //USER SESSION//
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  //CONSTRUCTOR DE LA BASE DE DATOS//
  static Future<Database> openDB() async
  {
    return openDatabase(join(await getDatabasesPath(),'tot.db'),
      onCreate: (db, version) async
      {
        await db.execute(
          "CREATE TABLE subject (id INTEGER PRIMARY KEY,id_user INTEGER,name TEXT,subject_code TEXT,professor_name TEXT,created_at TEXT,updated_at TEXT)"    
        );

        await db.execute(
          "CREATE TABLE tasks (id INTEGER PRIMARY KEY, id_user INTEGER, name TEXT, description TEXT, delivery_date TEXT, subject TEXT, type TEXT, status TEXT, created_at TEXT, updated_at TEXT)"
        );

        await db.execute(
          "CREATE TABLE sql_commands (command TEXT)"
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
    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    return result;
  }

  static Future<int?> insertSubjectSync(Subject newSubject) async
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
  }

  //UPDATE//
  static Future<int?> updateSubject(Subject newSubject) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    //OBTENER EL NOMBRE OLD//
    var oldSubject = await database.query('subject', where: 'id = ?', whereArgs: [newSubject.id]);
    String nameOld = "";
    for(int i = 0; i<oldSubject.length; i++)
    {
      nameOld=oldSubject[i]['name'].toString();
    }
    //CONSTRUIMOS EL SQL//
    var sql = "UPDATE subject SET name = '${newSubject.name}', subject_code = '${newSubject.subject_code}', professor_name = '${newSubject.professor_name}', updated_at = '${today}' WHERE id = ${newSubject.id}";
    var sqlTask = "UPDATE tasks SET subject = '${newSubject.name}' WHERE subject = '$nameOld'";
    //EJECUTAMOS EL SQL//
    var result = await database.rawUpdate(sql);
    var resultTrigger = await database.rawUpdate(sqlTask);
    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    return result;
  }

  //DELETE//
  static Future<int?> deleteSubject(String idSubject) async {

    Database database = await openDB();

    var sql = "DELETE FROM subject WHERE id = $idSubject";

    var result = await database.rawDelete(sql);

    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);

    return result;

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

  //ELIMINAR TODOS//
  static Future<int?> deleteAllSubjects() async {

    Database database = await openDB();

    var result = await database.delete("subject");
    return result;

  }

  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <CLASE> -----------------------------------------------------//
  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <TAREA> -----------------------------------------------------//
  //OBTENER TODOS//
  static Future<List<Task?>> getTasks() async {

    Database database = await openDB();

    final List<Map<String, dynamic>> taskList = await database.query('tasks', where: 'id_user = ?', whereArgs: [db().userSession.id]);

    return List.generate(taskList.length, (i) => Task(
      id: taskList[i]['id'].toString(),
      idUser: taskList[i]['id_user'].toString(),
      name: taskList[i]['name'],
      description: taskList[i]['description'],
      deliveryDate: taskList[i]['delivery_date'],
      subject: taskList[i]['subject'],
      type: taskList[i]['type'],
      status: taskList[i]['status'],
    ));

  }

  static Future<String?> getOneTask(String? idTask) async {

    Database database = await openDB();

    final List<Map<String, dynamic>> taskList = await database.query('tasks', where: 'id = ?', whereArgs: [idTask]);
    var created_at = taskList[0]['created_at'].toString();
  
    return created_at;

  }
  
  //OBTENER POR STATUS//
  static Future<List<Task?>> getTasksByStatus(String status) async {

    Database database = await openDB();

    var sql = "SELECT id, id_user, name, description, delivery_date, subject, type, status "
              "FROM tasks WHERE status = '$status'";

    final List<Map<String, dynamic>> taskList = await database.rawQuery(sql);

    return List.generate(taskList.length, (i) => Task(
      id: taskList[i]['id'].toString(),
      idUser: taskList[i]['id_user'].toString(),
      name: taskList[i]['name'],
      description: taskList[i]['description'],
      deliveryDate: taskList[i]['delivery_date'],
      subject: taskList[i]['subject'],
      type: taskList[i]['type'],
      status: taskList[i]['status'],
    ));

  }
  
  //INSERT//
  static Future<int?> insertTask(Task task) async {
    
    Database database = await openDB();
    
    var today = DateTime.now().toString();
    
    var sql = "INSERT INTO tasks(id_user, name, description, delivery_date, subject, type, status, created_at, updated_at) VALUES ( ${task.idUser}, '${task.name}', '${task.description}', '${task.deliveryDate}', '${task.subject}', '${task.type}', '${task.status}', '$today', '$today')";
    print(sql);
    var result = await database.rawInsert(sql);

    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    
    return result;

  }

  //INSERT//
  static Future<int?> insertTaskSync(Task task) async {
    
    Database database = await openDB();
    
    var today = DateTime.now().toString();
    
    var sql = "INSERT INTO tasks(id, id_user, name, description, delivery_date, subject, type, status, created_at, updated_at) VALUES ( ${task.id}, ${task.idUser}, '${task.name}', '${task.description}', '${task.deliveryDate}', '${task.subject}', '${task.type}', '${task.status}', '$today', '$today')";
    print(sql);
    var result = await database.rawInsert(sql);
    
    return result;

  }

  static Future<int?> updateTask(Task task) async {

    Database database = await openDB();

    var today = DateTime.now().toString();

    var sqlBase = "UPDATE tasks SET name = '${task.name}', description = '${task.description}', delivery_date = '${task.deliveryDate}', subject = '${task.subject}', type = '${task.type}', status = '${task.status}', updated_at = '$today' WHERE id_user = ${task.idUser}";

    var sql = sqlBase + "and id = ${task.id} ";

    var result = await database.rawUpdate(sql);

    var sqlSync = sqlBase + " and created_at = $today";
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    var resultSync = await database.rawInsert(sqlReplica);

    return result;

  }

  //UPDATE//
  static Future<int?> updateTaskStatus(String idTask, String status) async {

    Database database = await openDB();

    var today = DateTime.now().toString();

    var sqlBase = "UPDATE tasks SET status = '$status', updated_at = '$today' WHERE id_user = ${db().userSession.id}";

    var sql = sqlBase+" and id = $idTask";

    var result = await database.rawUpdate(sql);

    //ALMACENAR LOS SQL//
    var sqlSync = sqlBase + " and updated_at = $today";
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    var resultSync = await database.rawInsert(sqlReplica);

    return result;

  }

  //DELETE//
  static Future<int?> deleteTask(Task? task) async {

    Database database = await openDB();

    var sqlBase = "DELETE FROM tasks WHERE id_user = ${task!.idUser}";

    var sql = sqlBase + "and id = ${task.id} ";

    Future<String?> oldTaskCreated = getOneTask(task.id);
    
    var result = await database.rawDelete(sql);
  
    var sqlSync = sqlBase + " and created_at = $oldTaskCreated";

    //ALMACENAR LOS SQL//
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    var resultSync = await database.rawInsert(sqlReplica);
    
    return result;

  }

  //ELIMINAR TODOS//
  static Future<int?> deleteAllTasks() async {

    Database database = await openDB();
    var result = await database.delete("tasks");

    return result;

  }
  //-------------------------------------------------------------------------------------------------------------------//

  //-------------------------------------------------- <COMMANDS> -----------------------------------------------------//
  //LIMPIAR TODAS LAS TABLAS//
  static void clearAll() async 
  {
    //VACIAR TODAS LAS TABLAS//
    deleteAllTasks();
    deleteAllSubjects();
    deleteCommands();

    createReplica();
  }

  //OBTENER TODOS LOS COMANDOS//
  static Future<List<Query>> getAllCommands() async
  {
    Database database = await openDB();
    List<String> sCommands = [];
    final List<Map<String, dynamic>> commandsList = await database.query('sql_commands');

    return List.generate(commandsList.length, (i) => Query(
      command: commandsList[i]['command'],
    ));
  }

  //LIMPIAR LISTA DE COMANDOS//
  static Future<int?> deleteCommands() async {

    Database database = await openDB();

    var result = await database.delete("sql_commands");

    return result;

  }
  //-------------------------------------------------------------------------------------------------------------------//

  
}
  //--------------------------------------------------- <REPLICA> -----------------------------------------------------//
  void createReplica() async
  {

      print("Generando replica");

      //PROVIDERS//
      TasksProvider tasksProvider = TasksProvider();
      SubjectProvider subjectProvider = SubjectProvider();

      //USER SESSION//
      User userSession = User.fromJson(GetStorage().read('user') ?? {});

      //RECUPERAMOS LOS OBJETOS DEL PROVIDER//

      //TAREAS//
      List<Task?> tasks = [];
      tasks = await tasksProvider.getByUserAndStatus(userSession.id ?? '0', "COMPLETADO");

      for(int i = 0; i < tasks.length; i++)
      {
        db.insertTaskSync(tasks[i]!);
      }

      tasks = await tasksProvider.getByUserAndStatus(userSession.id ?? '0', "PENDIENTE");

      for(int i = 0; i < tasks.length; i++)
      {
        db.insertTaskSync(tasks[i]!);
      }

      //MATERIAS//
      List<Subject?> subjects = [];
      subjects = await subjectProvider.findByUser(userSession.id ?? '0');

      for(int i = 0; i < subjects.length; i++)
      {
        db.insertSubjectSync(subjects[i]!);
      }

    //CLASE//
  }
  //-------------------------------------------------------------------------------------------------------------------//

  //------------------------------------------------ <SINCRONIZACION> -------------------------------------------------//
  void createSync() async
  {
      print("Realizando Sincronización...");

      //PROVIDERS//
      SyncProvider syncProvider = SyncProvider();

      //USER SESSION//
      User userSession = User.fromJson(GetStorage().read('user') ?? {});

      List<Query> command = await db.getAllCommands();

      for(int i = 0; i<command.length; i++)
      {
        syncProvider.create(command[i]);
      }

      db.clearAll();
      

  }
  //-------------------------------------------------------------------------------------------------------------------//