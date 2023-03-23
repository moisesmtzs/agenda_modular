import 'dart:async';
import 'dart:io';
import 'package:agenda_app/src/models/query.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
//MODELOS//
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/clase.dart';
//SQLITE//
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//PROVIDERS//
import '../models/connectivity.dart';
import '../providers/subjectProvider.dart';
import '../providers/syncProvider.dart';
import '../providers/tasksProvider.dart';
import '../providers/claseProvider.dart';

class db
{
  //PROVIDERS//
  TasksProvider tasksProvider = TasksProvider();
  SubjectProvider subjectProvider = SubjectProvider();
  ClaseProvider claseProvider = ClaseProvider();

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
          "CREATE TABLE clase (id INTEGER PRIMARY KEY, id_user INTEGER, id_subject INTEGER, subjectName TEXT, begin_hour TEXT, end_hour TEXT, days TEXT, classroom TEXT, building TEXT, created_at TEXT, updated_at TEXT)"
        );

        await db.execute(
          "CREATE TABLE sql_commands (command TEXT)"
        );
      }, version: 1);
  }
  //----------------------------------------------------- <TAREA> -----------------------------------------------------//
  //OBTENER TODOS//
  static Future<List<Task?>> getTasks() async {
    //VERIFICAMOS QUE EXISTA LA BASE DE DATOS//
    Database database = await openDB();
    //OBTIENE TODOS LOS REGISTROS//
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

  //OBTENER UNO//
  static Future<String?> getOneTask(String? idTask) async {

    Database database = await openDB();

    final List<Map<String, dynamic>> taskList = await database.query('tasks', where: 'id = ?', whereArgs: [idTask]);
    String? createdAt = taskList[0]['created_at'];

    return createdAt;

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
    //INSERTAMOS EL REGISTRO EN LA BASE DE DATOS LOCAL//
    Database database = await openDB();
    
    //TRANSFORMARMOS LA FECHA DE HOY EN EL FORMATO CORRECTO//
    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO tasks(id_user, name, description, delivery_date, subject, type, status, created_at, updated_at) VALUES ( ${task.idUser}, '${task.name}', '${task.description}', '${task.deliveryDate}', '${task.subject}', '${task.type}', '${task.status}', '$formatted', '$formatted')";
    
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);

    //ALMACENAR EL COMANDO SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    
    return result;
  }

  //INSERT SYNC//
  static Future<int?> insertTaskSync(Task task) async {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    Map<String, dynamic>? today = await db.findDatesTask(task);
    String createdAt = today!['created_at'];
    String updatedAt = today!['updated_at'];

    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO tasks(id, id_user, name, description, delivery_date, subject, type, status, created_at, updated_at) VALUES ( ${task.id}, ${task.idUser}, '${task.name}', '${task.description}', '${task.deliveryDate}', '${task.subject}', '${task.type}', '${task.status}', '$createdAt', '$updatedAt')";
    
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);
    
    return result;

  }

  static Future<Map<String, dynamic>?> findDatesTask(Task task) async{
    TasksProvider tasksProvider = TasksProvider();
    Map<String, dynamic>? dates = await tasksProvider.getDatesById(task.id);
    
    return dates;

  }

  //UPDATE//
  static Future<int?> updateTask(Task task) async {
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();

    //CONSTRUIMOS EL SQL//
    var sqlBase = "UPDATE tasks SET name = '${task.name}', description = '${task.description}', delivery_date = '${task.deliveryDate}', subject = '${task.subject}', type = '${task.type}', status = '${task.status}', updated_at = '$formatted' WHERE id_user = ${task.idUser}";
    var sql = sqlBase + " and id = ${task.id} ";

    //EJECUTAMOS EL SQL//
    var result = await database.rawUpdate(sql);

    //ALMACENAR LOS SQL//
    String? createdAt = await getOneTask(task.id);
    var sqlSync = sqlBase + " and created_at = '$createdAt'";
    var sqlReplica = "INSERT INTO sql_commands values (\"$sqlSync\")";
    await database.rawInsert(sqlReplica);

    return result;

  }

  static Future<int?> updateTaskStatus(String idTask, String status) async {

    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    Database database = await openDB();

    var sqlBase = "UPDATE tasks SET status = '$status', updated_at = '$formatted' WHERE id_user = ${db().userSession.id}";

    var sql = sqlBase + " and id = $idTask";

    var result = await database.rawUpdate(sql);

    String? createdAt = await getOneTask(idTask);

    var sqlSync = sqlBase + " and created_at = '$createdAt'";
    var sqlReplica = "INSERT INTO sql_commands values (\"$sqlSync\")";
    
    await database.rawInsert(sqlReplica);

    return result;

  }

  //DELETE//
  static Future<int?> deleteTask(Task? task) async {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();

    //CONSTRUIMOS EL SQL//
    var sqlBase = "DELETE FROM tasks WHERE id_user = ${task!.idUser}";
    var sql = sqlBase + " and id = ${task.id} ";

    //OBTENEMOS LA FECHA DE CREACION ORIGINAL//
    String? oldTaskCreated = await getOneTask(task.id);
    
    //EJECUTAMOS EL SQL//
    var result = await database.rawDelete(sql);
  
    //ALMACENAR LOS SQL//
    var sqlSync = sqlBase + " and created_at = '$oldTaskCreated'";
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    await database.rawInsert(sqlReplica);
    
    return result;

  }

  //ELIMINAR TODOS//
  static Future<int?> deleteAllTasks() async {

    Database database = await openDB();
    var result = await database.delete("tasks");

    return result;

  }
  //-------------------------------------------------------------------------------------------------------------------//

  //---------------------------------------------------- <MATERIA> ----------------------------------------------------//

  //OBTENER TODOS//
  static Future<List<Subject>> getSubjects() async
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

  //OBTENER UNO//
  static Future<String?> getOneSubject(String? idSubject) async {

    Database database = await openDB();

    final List<Map<String, dynamic>> subjectList = await database.query('subject', where: 'id = ?', whereArgs: [idSubject]);
    String? created_at = subjectList[0]['created_at'];

    return created_at;

  }

  static Future<Subject> getOneSubjectAll(String? idSubject) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS TODOS LOS ELEMENTOS DE LA TABLA INDICADA//
    print(idSubject);
    final List<Map<String, dynamic>> subjectList  = await database.query('subject', where: 'id = ?', whereArgs: [idSubject]);
    //RECORREMOS CADA ELEMENTO PARA CONSTRUIR EL OBJETO SUBJECT POR CADA UNO//
    return Subject(
      id: subjectList[0]['id'].toString(),
      id_user: subjectList[0]['id_user'].toString(),
      name: subjectList[0]['name'],
      subject_code: subjectList[0]['subject_code'],
      professor_name: subjectList[0]['professor_name'],
    );
  }

  static Future<Subject> getOneSubjectByName(String? name) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS TODOS LOS ELEMENTOS DE LA TABLA INDICADA//
    final List<Map<String, dynamic>> subjectList  = await database.query('subject', where: 'name = ?', whereArgs: [name]);
    //RECORREMOS CADA ELEMENTO PARA CONSTRUIR EL OBJETO SUBJECT POR CADA UNO//
    return Subject(
      id: subjectList[0]['id'].toString(),
      id_user: subjectList[0]['id_user'].toString(),
      name: subjectList[0]['name'],
      subject_code: subjectList[0]['subject_code'],
      professor_name: subjectList[0]['professor_name'],
    );
  }

  //INSERT//
  static Future<int?> insertSubject(Subject newSubject) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();

    //TRANSFORMARMOS LA FECHA DE HOY EN EL FORMATO CORRECTO//
    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO subject(id_user, name, subject_code, professor_name, created_at, updated_at) VALUES ( ${newSubject.id_user}, '${newSubject.name}', '${newSubject.subject_code}', '${newSubject.professor_name}', '$formatted', '$formatted')";
    
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);

    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);

    return result;
  }

  //INSERT SYNC//
  static Future<int?> insertSubjectSync(Subject newSubject) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();

    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    Map<String, dynamic>? today = await db.findDatesSubjects(newSubject);
    String createdAt = today!['created_at'];
    String updatedAt = today!['updated_at'];

    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO subject(id_user, name, subject_code, professor_name, created_at, updated_at) VALUES ( ${newSubject.id_user}, '${newSubject.name}', '${newSubject.subject_code}', '${newSubject.professor_name}', '${createdAt}', '${updatedAt}')";
    
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);

    return result;
  }

  static Future<Map<String, dynamic>?> findDatesSubjects(Subject subject) async{
    SubjectProvider subjectProvider = SubjectProvider();
    Map<String, dynamic>? dates = await subjectProvider.getDatesById(subject.id);
    
    return dates;
  }

  //UPDATE//
  static Future<int?> updateSubject(Subject newSubject) async
  {
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();

    //OBTENER MATERIA ANTERIOR//
    var oldSubject = await database.query('subject', where: 'id = ?', whereArgs: [newSubject.id]);
    String nameOld = "";
    for(int i = 0; i<oldSubject.length; i++)
    {
      nameOld=oldSubject[i]['name'].toString();
    }
    
    //CONSTRUIMOS EL SQL//
    var sqlBase = "UPDATE subject SET name = '${newSubject.name}', subject_code = '${newSubject.subject_code}', professor_name = '${newSubject.professor_name}', updated_at = '${formatted}' WHERE id_user = ${newSubject.id_user}";
    var sql = sqlBase + " and id = ${newSubject.id} ";

    //TRIGGER//
    var sqlTask = "UPDATE tasks SET subject = '${newSubject.name}' WHERE subject = '$nameOld'";

    //EJECUTAMOS EL SQL//
    var result = await database.rawUpdate(sql);

    //EJECUTAMOS EL TRIGGER//
    var resultTrigger = await database.rawUpdate(sqlTask);

    //ALMACENAR LOS SQL//
    String? createdAt = await getOneSubject(newSubject.id);
    var sqlSync = sqlBase + " and created_at = '$createdAt'";
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    await database.rawInsert(sqlReplica);

    return result;
  }

  //DELETE//
  static Future<int?> deleteSubject(Subject newSubject) async {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    
    //CONSTRUIMOS EL SQL//
    var sqlBase = "DELETE FROM subject WHERE id_user = ${newSubject.id_user}";
    var sql = sqlBase + " and id = ${newSubject.id} ";

    //OBTENEMOS LA FECHA DE CREACION ORIGINAL//
    String? oldSubjectCreated = await getOneSubject(newSubject.id);

    //EJECUTAMOS EL SQL//
    var result = await database.rawDelete(sql);

    //ALMACENAR LOS SQL//
    var sqlSync = sqlBase + " and created_at = '$oldSubjectCreated'";
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    await database.rawInsert(sqlReplica);

    return result;

  }

  //ELIMINAR TODOS//
  static Future<int?> deleteAllSubjects() async {

    Database database = await openDB();

    var result = await database.delete("subject");
    return result;

  }

  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <CLASE> -----------------------------------------------------//
  //OBTENER TODAS//
  static Future<List<Clase?>> getClases() async 
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS TODOS LOS ELEMENTOS DE LA TABLA INDICADA//
    final List<Map<String, dynamic>> claseList  = await database.query('clase');
    //RECORREMOS CADA ELEMENTO PARA CONSTRUIR EL OBJETO SUBJECT POR CADA UNO//
    return List.generate(claseList.length, (i) => Clase(
      id: claseList[i]['id'].toString(),
      id_user: claseList[i]['id_user'].toString(),
      id_subject: claseList[i]['id_subject'].toString(),
      subjName: claseList[i]['subjectName'],
      begin_hour: claseList[i]['begin_hour'],
      end_hour: claseList[i]['end_hour'],
      days: claseList[i]['days'],
      classroom: claseList[i]['classroom'],
      building: claseList[i]['building'],
    ));
  }

  //OBTENER UNO CREATED//
  static Future<String?> getOneClase(String? idClase) async {

    Database database = await openDB();

    final List<Map<String, dynamic>> claseList = await database.query('clase', where: 'id = ?', whereArgs: [idClase]);
    String created_at = claseList[0]['created_at'];
  
    return created_at;
  }

  //OBTENER UNO//
  static Future<Clase?> getOneClaseAll(String? idClase) async 
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS TODOS LOS ELEMENTOS DE LA TABLA INDICADA//
    final List<Map<String, dynamic>> claseList  = await database.query('clase', where: 'id = ?', whereArgs: [idClase]);
    //RECORREMOS CADA ELEMENTO PARA CONSTRUIR EL OBJETO SUBJECT POR CADA UNO//
    return Clase(
      id: claseList[0]['id'].toString(),
      id_user: claseList[0]['id_user'].toString(),
      id_subject: claseList[0]['id_subject'].toString(),
      begin_hour: claseList[0]['begin_hour'],
      end_hour: claseList[0]['end_hour'],
      days: claseList[0]['days'],
      classroom: claseList[0]['classroom'],
      building: claseList[0]['building'],
    );
  }

  //OBTENER TODAS//
  static Future<List<Clase?>> getClasesBySubject(Subject subject) async 
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS TODOS LOS ELEMENTOS DE LA TABLA INDICADA//
    Subject? subj = await getOneSubjectByName(subject.name);

    final List<Map<String, dynamic>> claseList  = await database.query('clase', where: 'subjectName = ?', whereArgs: [subj.name]);
    print(claseList.length);
    //RECORREMOS CADA ELEMENTO PARA CONSTRUIR EL OBJETO SUBJECT POR CADA UNO//
    return List.generate(claseList.length, (i) => Clase(
      id: claseList[i]['id'].toString(),
      id_user: claseList[i]['id_user'].toString(),
      subjName: claseList[i]['subjectName'],
      id_subject: claseList[i]['id_subject'].toString(),
      begin_hour: claseList[i]['begin_hour'],
      end_hour: claseList[i]['end_hour'],
      days: claseList[i]['days'],
      classroom: claseList[i]['classroom'],
      building: claseList[i]['building'],
    ));
  }

  //OBTENER UNO//
  static Future<Clase?> getByIdDayBegin(String? beginhour, String? daysP) async 
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS TODOS LOS ELEMENTOS DE LA TABLA INDICADA//
    beginhour = beginhour!.substring(0,(beginhour!.length-4));
    final List<Map<String, dynamic>> claseList  = await database.query('clase', where: 'begin_hour = ? and days = ?', whereArgs: [beginhour, daysP]);
  print(claseList.length);
    //RECORREMOS CADA ELEMENTO PARA CONSTRUIR EL OBJETO SUBJECT POR CADA UNO//
    return Clase(
      id: claseList[0]['id'].toString(),
      id_user: claseList[0]['id_user'].toString(),
      id_subject: claseList[0]['id_subject'].toString(),
      begin_hour: claseList[0]['begin_hour'],
      end_hour: claseList[0]['end_hour'],
      days: claseList[0]['days'],
      classroom: claseList[0]['classroom'],
      building: claseList[0]['building'],
    );
  }

  //INSERTAR//
  static Future<int?> insertClase(Clase newClase) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //TRANSFORMARMOS LA FECHA DE HOY EN EL FORMATO CORRECTO//
    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);
    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO clase(id_user, id_subject, begin_hour, end_hour, days, classroom, building, created_at, updated_at) VALUES ( ${newClase.id_user}, '${newClase.id_subject}', '${newClase.begin_hour}', '${newClase.end_hour}', '${newClase.days}', '${newClase.classroom}', '${newClase.building}','${formatted}', '${formatted}')";
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);
    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    return result;
  }

  //INSERTAR SYNC//
  static Future<int?> insertClaseSync(Clase newClase, String nombreMateria) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();

    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    Map<String, dynamic>? today = await db.findDatesClase(newClase);
    String createdAt = today!['created_at'];
    String updatedAt = today!['updated_at'];

    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO clase(id_user, id_subject, subjectName, begin_hour, end_hour, days, classroom, building, created_at, updated_at) VALUES ( ${newClase.id_user}, '${newClase.id_subject}', '$nombreMateria', '${newClase.begin_hour}', '${newClase.end_hour}', '${newClase.days}', '${newClase.classroom}', '${newClase.building}','$createdAt', '$updatedAt')";
    
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);

    return result;
  }

  static Future<Map<String, dynamic>?> findDatesClase(Clase newClase) async{
    ClaseProvider claseProvider = ClaseProvider();
    Map<String, dynamic>? dates = await claseProvider.getDatesById(newClase.id);
    return dates;
  }

  //UPDATE//
  static Future<int?> updateClase(Clase clase) async {
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();

    //CONSTRUIMOS EL SQL//
    var sqlBase = "UPDATE clase SET begin_hour = '${clase.begin_hour}', end_hour = '${clase.end_hour}', days = '${clase.days}', classroom = '${clase.classroom}', building = '${clase.building}', updated_at = '$today' WHERE id_user = ${clase.id_user}";
    var sql = sqlBase + "and id = ${clase.id} ";

    //EJECUTAMOS EL SQL//
    var result = await database.rawUpdate(sql);

    //ALMACENAR LOS SQL//
    String? createdAt = await getOneSubject(clase.id);
    var sqlSync = sqlBase + " and created_at = '$createdAt'";
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    await database.rawInsert(sqlReplica); 

    return result;
  }

  //DELETE//
  static Future<int?> deleteClase(Clase? clase) async {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();

    //CONSTRUIMOS EL SQL//
    var sqlBase = "DELETE FROM clase WHERE id_user = ${clase!.id_user}";
    var sql = sqlBase + " and id = ${clase.id} ";

    //OBTENEMOS LA FECHA DE CREACION ORIGINAL//
    String? oldClaseCreated = await getOneClase(clase.id);

    //EJECUTAMOS EL SQL//
    var result = await database.rawDelete(sql);

    //ALMACENAR LOS SQL//
    var sqlSync = sqlBase + " and created_at = '$oldClaseCreated'";
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    var resultSync = await database.rawInsert(sqlReplica);
    
    return result;
  }

  //ELIMINAR TODOS//
  static Future<int?> deleteAllClases() async {

    Database database = await openDB();
    var result = await database.delete("clase");

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
    deleteAllClases();
    deleteCommands();
  }

  //OBTENER TODOS LOS COMANDOS//
  static Future<List<Query>> getAllCommands() async
  {
    Database database = await openDB();

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
  Future createReplica() async
  {
      print("INICIANDO REPLICA");

      //PROVIDERS//
      TasksProvider tasksProvider = TasksProvider();
      SubjectProvider subjectProvider = SubjectProvider();
      ClaseProvider claseProvider = ClaseProvider();

      //USER SESSION//
      User userSession = User.fromJson(GetStorage().read('user') ?? {});

      //RECUPERAMOS LOS OBJETOS DEL PROVIDER//

      //LIMPIAMOS BD REPLICA//
      db.clearAll();

      //TAREAS//
      List<Task?> tasks = [];
      tasks = await tasksProvider.getByUserAndStatus(userSession.id ?? '0', "COMPLETADO");

      for(int i = 0; i < tasks.length; i++)
      {
        await db.insertTaskSync(tasks[i]!);
      }

      tasks = await tasksProvider.getByUserAndStatus(userSession.id ?? '0', "PENDIENTE");

      for(int i = 0; i < tasks.length; i++)
      {
        await db.insertTaskSync(tasks[i]!);
      }

      //MATERIAS//
      List<Subject?> subjects = [];
      subjects = await subjectProvider.findByUser(userSession.id ?? '0');

      for(int i = 0; i < subjects.length; i++)
      {
        await db.insertSubjectSync(subjects[i]!);
      }

    //CLASE//
    List<Clase?> clases = [];
    clases = await claseProvider.findByUser(userSession.id ?? '0');//aquiii

    for(int i = 0; i < clases.length; i++)
    {
      Subject? subjectActual = await subjectProvider.findById(clases[i]!.id_subject!);
      String? nombreMateria = subjectActual?.name;
      await db.insertClaseSync(clases[i]!,nombreMateria!);
    }

    print("REPLICA FINALIZADA");
  }
  //-------------------------------------------------------------------------------------------------------------------//

  //------------------------------------------------ <SINCRONIZACION> -------------------------------------------------//
  void createSync() async
  {
      print("INICIA LA SINCRONIZACION");

      //PROVIDERS//
      SyncProvider syncProvider = SyncProvider();

      //USER SESSION//
      User userSession = User.fromJson(GetStorage().read('user') ?? {});

      List<Query> command = await db.getAllCommands();

      for( int i = 0 ; i < command.length ; i++ )
      {
        await syncProvider.create(command[i]);
        print("COMANDO: ${command[i].command.toString()}");
      }

      print(" <<<< SE SINCRONIZARON "+command.length.toString()+" COMANDOS. >>>>");

      await createReplica();

      print("SINCRONIZACION FINALIZADA");
  }
  //-------------------------------------------------------------------------------------------------------------------//