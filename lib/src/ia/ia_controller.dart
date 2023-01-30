import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/models/ia_task.dart';
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';

import 'package:agenda_app/src/providers/ia_taskProvider.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';

import 'package:agenda_app/src/ia/text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../models/command.dart';

class IA_Controller
{
  // ----------------------------------ATRIBUTOS IA-------------------------------------------- //
 
  stt.SpeechToText _speech = stt.SpeechToText(); //ENCARGADO DE ESCUCHAR//
  bool _isListening = false; //BOOLEANO QUE DETERMIAN EL ESTADO DE LA VOZ//
  double _confidence = 1.0; //CONFIABILIDAD//

  String _text = "¿En que puedo ayudarte?"; //MENSAJE A ANALIZAR//
  String _stext = "¿En que puedo ayudarte?"; //MENSAJE AL USUARIO//
  
  VoiceRosalind _voice = new VoiceRosalind(); //ENCARGADO DE HABLAR//

  final ia_taskProvider ia_provider =  Get.put(ia_taskProvider()); //IA PROVIDER//

  List<ia_task?> commandsBD = []; //COMANDOS//

  List<command?> posCommands = []; //POSIBLES COMANDOS//

  List<command?> descartList = []; //LISTA DE COMANDOS DESCARTADOS//

  String newCommand = "";
  
  //BANDERAS//
  bool exist = false;
  bool isNewCommand = false;
  
  //ESTADOS//
  int waitAnswer = -1;
  
  // ---------------------------------------------------------------------------------------- //

  // ---------------------------------ATRIBUTOS ACCION--------------------------------------- //
  
  //VARIABLES
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  //PROVIDERS//
  final SubjectProvider subject_provider =  Get.put(SubjectProvider());
  final TasksProvider task_provider =  Get.put(TasksProvider());

  //BANDERAS//

  
  //ESTADOS//
  int actualType = 0, actualObj = 0, actualProcess = 0;

  //OBJETOS CON LOS QUE TRABAJARA LA IA//
  Task NewTask = new Task();
  Task? taskDb;

  Subject NewSubject = new Subject();
  Subject? subjectDB;
  
  // ---------------------------------------------------------------------------------------- //

  //CONSTRUCTOR//
  IA_Controller() {
    _speech = stt.SpeechToText();
    _voice = new VoiceRosalind();
  }

  // ----------------------------------METODO DE BUSQUEDA------------------------------------ //

  //ANALIZAR SI EL COMANDO ES VALIDO//
  void isCommand(String textSpeak) async 
  {
    debugPrint(actualType.toString() + "|" + actualObj.toString());
    //CANCELAR ACCION//
    if(_stext.toUpperCase() == "CANCELAR")
    {
      _voice.speak("Cancelando...");
      resetIA();
    }
    else if(actualType != 0 && actualObj != 0)
    {
      executeCommand();
    }
    //SI SE ESPERA UNA RESPUESTA//  
    else if(waitAnswer != -1)
    {
      searchNewCommand();
    }
    else
    {
      debugPrint(_stext);

      //BUSCAR MALAS PALABRAS//
      if(badwords())
      {
        List<String> words = [];
        int cont = _text.length;
        String actualWord="";
        //SEPARAR POR PALABRAS//
        for (var i=0; i<cont; i++)
        {
          if(_text[i]==" "||i==cont-1)
          {
            if(i==cont-1)
            {
              actualWord+=_text[i];
            }
            words.add(actualWord.toUpperCase());
            actualWord="";
          }
          else
          {
            actualWord+=_text[i];
          }
        }
        if(words.length<2)
        {
          _voice.speak("Lo siento, el comando no cuenta con palabras suficientes. Intenta de Nuevo");
          resetIA();
          return;
        }
        //BUSCAMOS EL COMANDO EN LA BD//
        String searchCommand = _stext.toUpperCase();
        List<ia_task?> bd_exist = await ia_provider.getByCommand(searchCommand);
        debugPrint("SIZE: "+bd_exist.length.toString());
        //SI EL COMANDO EXISTE//
        if(bd_exist.length>0)
        {
          //INSERTAR TAREA//
          if(bd_exist[0]!.obj=="1" && bd_exist[0]!.type=="1")
          {
            //CAMBIAR A MODO REGISTRAR TAREA//
            actualType=1;
            actualObj=1;
            actualProcess=1;
            NewTask = new Task();
            NewTask.idUser = userSession.id;    
            _voice.speak("Se agregará una nueva Tarea. ¿Cuál es el nombre de la tarea?");
            _stext = "¿Cual es el nombre de la tarea?";
          }
          //ELIMINAR TAREA//
          else if(bd_exist[0]!.obj=="1" && bd_exist[0]!.type=="3")
          {
            //CAMBIAR A MODO ELIMINAR TAREA//
            actualType=3;
            actualObj=1;
            actualProcess=1;
            NewTask = new Task();
            NewTask.idUser = userSession.id;    
            _voice.speak("Se eliminara una Tarea. ¿Cuál es el nombre de la tarea?");
            _stext = "¿Cual es el nombre de la tarea?";
          }
          //INSERTAR MATERIA//
          else if(bd_exist[0]!.obj=="2" && bd_exist[0]!.type=="1")
          {
            //CAMBIAR A MODO REGISTRAR MATERIA//
            actualType=1;
            actualObj=2;
            actualProcess=1;
            NewSubject = new Subject();
            NewSubject.id_user = userSession.id;    
            _voice.speak("Se agregará una nueva Materia. ¿Cuál es el nombre de la Materia?");
            _stext = "¿Cual es el nombre de la materia?";
          }
        }
        else
        {
          //RECUPERAR COMANDOS ALMACENADOS EN LA BD//
          commandsBD = await ia_provider.getAll();
          int commandSize = commandsBD.length, highSim = 0;
          exist = false;posCommands = [];
          //BUSCAR SIMILITUDES//
          for(int iCont = 0; iCont<commandSize; iCont++)
          {
            int numSimil = 0, descarted = 0;
            //POR CADA PALABRA DEL COMANDO ALMACENADO//
            for(int iCont2 = 0; iCont2<words.length; iCont2++)
            {
              //DESCARTAMOS PALABRAS MENORES A 4 LETRAS//
              if(words[iCont2].length>=4)
              {
                //BUSCAR SI LA PALABRA SE ENCUENTRA DENTRO//
                bool? contains = commandsBD[iCont]!.command?.contains(words[iCont2]);
                debugPrint(contains.toString());
                //SI HAY SIMILITUD, AUMENTA EL CONTADOR DE SIMILITUDES//
                if(contains == true)
                {
                  numSimil++;
                }
              }
            }
            //SI LAS SIMILITUDES SON MAYORES O IGUAL AL MAYOR NUMERO DE SIMILITUDES, ALMACENAMOS EL COMANDO//
            if(numSimil>=highSim && numSimil!=0)
            {    
              //SI LAS SIMILITUDES NO SON IGUALES//
              if(numSimil>highSim)
              {
                posCommands.clear();
              }
              //EL NUMERO ACTUAL SE CONVIERTE EN EL NUMERO MAYOR DE SIMILITUDES//
              highSim = numSimil;
              //ALMACENAMOS EL COMANDO//
              command newCommand = new command();
              newCommand.setSimil(highSim);
              newCommand.setTask(commandsBD[iCont]!);
              posCommands.add(newCommand); 
            }
          }
          //SI HAY SOLO UNA SIMILITUD//
          if(posCommands.length == 1)
          {
            //CREAMOS UNA IA TASK//
            ia_task newTask = new ia_task();
            newTask.command = _stext.toUpperCase();
            newTask.obj = posCommands[0]!.task!.obj;
            newTask.type = posCommands[0]!.task!.type;
            ia_provider.create(newTask);
            //INSERTAR TAREA//
            if(newTask.obj== "1" && newTask.type=="1")
            {
              //CAMBIAR A MODO REGISTRAR TAREA//
              actualType=1;
              actualObj=1;
              actualProcess=1;
              NewTask = new Task();
              NewTask.idUser = userSession.id;    
              _voice.speak("Se agregará una nueva Tarea. ¿Cuál es el nombre de la tarea?");
              _stext = "¿Cual es el nombre de la tarea?";
            }
            //ELIMINAR TAREA//
            else if(newTask.obj== "1" && newTask.type== "3")
            {
              //CAMBIAR A MODO ELIMINAR TAREA//
              actualType=3;
              actualObj=1;
              actualProcess=1;
              NewTask = new Task();
              NewTask.idUser = userSession.id;    
              _voice.speak("Se eliminara una Tarea. ¿Cuál es el nombre de la tarea?");
              _stext = "¿Cual es el nombre de la tarea?";
            }
            //INSERTAR MATERIA//
            else if(newTask.obj == "2" && newTask.type == "1")
            {
              //CAMBIAR A MODO REGISTRAR MATERIA//
              actualType=1;
              actualObj=2;
              actualProcess=1;
              NewSubject = new Subject();
              NewSubject.id_user = userSession.id;    
              _voice.speak("Se agregará una nueva Materia. ¿Cuál es el nombre de la Materia?");
              _stext = "¿Cual es el nombre de la materia?";
            }
            else
            {
              _voice.speak("NO ENTRE A NINGUN IF");
            }
          }
          //SI HAY MAS DE UNA SIMILITUD
          else if(posCommands.length > 1)
          {
            isNewCommand = true;
            newCommand = _stext.toUpperCase();
            waitAnswer=0;
            //PRIMER DESCARTE//
            searchNewCommand();

          }
          //SI NO HAY SIMILITUDES//
          else
          {
            _voice.speak("Lo siento, el comando es muy ambiguo");
            resetIA();
          }
          if(posCommands.isNotEmpty)
          {
            debugPrint("COMANDOS CREADOS FINAL: "+posCommands.length.toString());  
            debugPrint("COINCIDENCIAS FINALES: "+posCommands[0]!.simil.toString());
          }
        }
      }
      else
      {
        _voice.speak("Lo siento, no estan permitidas palabras antisonantes. Intenta de Nuevo");
        resetIA();
      } 
    } 
  }

  // ---------------------------------------------------------------------------------------- //

  /*
      TIPOS
        1.- INSERTAR
        2.- MODIFICAR
        3.- ELIMINAR
      
      OBJETOS
        1.- TAREA
        2.- MATERIA
        3.- CLASE
  */

  void searchNewCommand() async
  {
    //ESPERA UN SI O NO// 
    if(waitAnswer != 0)
    {
      debugPrint(_stext);
      //SI LA RESPUESTA ES NO//
      if(_stext.toUpperCase() == "NO")
      {
        if(posCommands.isNotEmpty)
        {
          debugPrint("EL SIZE ES: "+posCommands.length.toString());
          descartList.add(posCommands[0]);
          posCommands.removeAt(0);
          waitAnswer=0;
          if(posCommands.isNotEmpty)
          {
            posCommands.removeAt(0);
          }
          searchNewCommand();
          debugPrint(posCommands.toString());
        }
        else
        {
          _voice.speak("Lo siento, el comando es muy ambiguo");
          resetIA();
        }
      }
      //SI LA RESPUESTA ES SI//
      else if(_stext.toUpperCase() == "SÍ")
      {
        //INSERTAR TAREA//
        if(waitAnswer==1)
        {
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
          //CAMBIAR A MODO REGISTRAR TAREA//
          actualType=1;
          actualObj=1;
          NewTask = new Task();
          NewTask.idUser = userSession.id;    
          _voice.speak("¿Cual es el nombre de la tarea?");
          _stext = "¿Cual es el nombre de la tarea?";
        }
        //ELIMINAR TAREA//
        else if(waitAnswer==7)
        {
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
          //CAMBIAR A MODO ELIMINAR TAREA//
          actualType=1;
          actualObj=1;
          NewTask = new Task();
          NewTask.idUser = userSession.id;    
          _voice.speak("¿Cual es el nombre de la tarea?");
          _stext = "¿Cual es el nombre de la tarea?";
        }
        //INSERTAR MATERIA//
        else if(waitAnswer==2)
        {
          
          //CAMBIAR A MODO REGISTRAR MATERIA//
          actualType=1;
          actualObj=2;
          actualProcess=1;
          NewSubject = new Subject();
          NewSubject.id_user = userSession.id;    
          _voice.speak("Se agregará una nueva Materia. ¿Cuál es el nombre de la Materia?");
          _stext = "¿Cual es el nombre de la materia?";
        }
      }
      else
      {
        _voice.speak("Lo siento, solo puedes reponder Si o No");
      }
    }
    else
    {
      if(posCommands.isNotEmpty)
      {
        bool isDelete = false;
        for(int i = 0; i<descartList.length; i++)
        {
          if(posCommands[0]!.task!.type == descartList[i]!.task!.type)
          {
            if(posCommands[0]!.task!.obj == descartList[i]!.task!.obj)
            {
              posCommands.removeAt(0);
              isDelete = true;
            }
          }
        }
        if(isDelete == true)
        {
          searchNewCommand();
        }
        //INSERTAR//
        else if(posCommands[0]!.task!.type == "1")
        {
          //INSERTAR TAREA - waitAnswer: 1//
          if(posCommands[0]!.task!.obj == "1")
          {
            _voice.speak("¿Quieres insertar una Tarea?");
            _stext = "¿Quieres insertar una Tarea?";
            waitAnswer = 1;
          }
          //INSERTAR MATERIA - waitAnswer: 2//
          else if(posCommands[0]!.task!.obj == "2")
          {
            _voice.speak("¿Quieres insertar una Tarea?");
            _stext = "¿Quieres insertar una Tarea?";
            waitAnswer = 2;
          }
          //INSERTAR MATERIA - waitAnswer: 3//
          else if(posCommands[0]!.task!.obj == "3")
          {
            _voice.speak("¿Quieres insertar una Clase?");
            _stext = "¿Quieres insertar una Clase?";
            waitAnswer = 3;
          }
          else
          {
            _voice.speak("Lo siento, el comando es muy ambiguo");
            resetIA();
          }
        }
        //MODIFICAR//
        else if(posCommands[0]!.task!.type == "2")
        {
          //MODIFICAR TAREA - waitAnswer: 4//
          if(posCommands[0]!.task!.obj == "1")
          {
            _voice.speak("¿Quieres modificar una Tarea?");
            _stext = "¿Quieres modificar una Tarea?";
            waitAnswer = 4;
          }
          //MODIFICAR MATERIA - waitAnswer: 5//
          else if(posCommands[0]!.task!.obj == "2")
          {
            _voice.speak("¿Quieres modificar una Tarea?");
            _stext = "¿Quieres modificar una Tarea?";
            waitAnswer = 5;
          }
          //MODIFICAR MATERIA - waitAnswer: 6//
          else if(posCommands[0]!.task!.obj == "3")
          {
            _voice.speak("¿Quieres modificar una Clase?");
            _stext = "¿Quieres modificar una Clase?";
            waitAnswer = 6;
          }
          else
          {
            _voice.speak("Lo siento, el comando es muy ambiguo");
            resetIA();
          }
        }
        //ELIMINAR//
        else if(posCommands[0]!.task!.type == "3")
        {
          //MODIFICAR TAREA - waitAnswer: 7//
          if(posCommands[0]!.task!.obj == "1")
          {
            _voice.speak("¿Quieres eliminar una Tarea?");
            _stext = "¿Quieres eliminar una Tarea?";
            waitAnswer = 7;
          }
          //MODIFICAR MATERIA - waitAnswer: 8//
          else if(posCommands[0]!.task!.obj == "2")
          {
            _voice.speak("¿Quieres eliminar una Tarea?");
            _stext = "¿Quieres eliminar una Tarea?";
            waitAnswer = 8;
          }
          //MODIFICAR MATERIA - waitAnswer: 9//
          else if(posCommands[0]!.task!.obj == "3")
          {
            _voice.speak("¿Quieres eliminar una Clase?");
            _stext = "¿Quieres eliminar una Clase?";
            waitAnswer = 9;
          }
          else
          {
            _voice.speak("Lo siento, el comando es muy ambiguo");
            resetIA();
          }
        }
        else
        {
          _voice.speak("Lo siento, el comando es muy ambiguo");
          resetIA();
        }
      }
      else
      {
        _voice.speak("Lo siento, el comando es muy ambiguo");
        resetIA();
      }
    }  
  }

  // -----------------------------------METODOS DE CONTROL----------------------------------- //

  //FUNCION PARA DEJAR DE ESCUCHAR//
  void stopListening() 
  {
    _speech.stop();
  }

  //BUSCAR MALAS PALABRAS//
  bool badwords() 
  {
    int sizeText = _text.length;
    //BUSCAR *//
    for (var i = 0; i < sizeText; i++)
    {
      //ENCONTRO UN *//
      if(_text[i]=='*')
      {
        return false;
      }
    }
    return true;
  }

  //REINICIAR IA//
  void resetIA() 
  {
    _text = "¿En que puedo ayudarte?"; 
    _stext = "¿En que puedo ayudarte?";
    commandsBD = [];
    posCommands = []; 
    descartList = []; 
    newCommand = "";
    exist = false;
    isNewCommand = false;
    waitAnswer = -1;
    actualType = 0;
    actualObj = 0;
    actualProcess = 0;
  }

  // ------------------------------------SETTERS|GETTERS------------------------------------ //

  //GETTERS//
  String getText()
  {
    return _text;
  }

  String getsText()
  {
    return _stext;
  }

  double getConfidence()
  {
    return _confidence;
  }

  bool getListening()
  {
    return _isListening;
  }

  stt.SpeechToText getSpeech()
  {
    return _speech;
  }

  //SETTERS//
  void setText(String NewText)
  {
    _text = NewText;
  }

  void setsText(String NewText)
  {
    _stext = NewText;
    _text = NewText;
  }

  void setListening(bool NewListening)
  {
    _isListening = NewListening;
  }

  void setConfidence(double NewConfidence)
  {
    _confidence=NewConfidence;
  }

  // ---------------------------------------------------------------------------------------- //


  // ------------------------------------COMANDOS POR VOZ------------------------------------ //
  Future<void> executeCommand()
  async {
    //INSERTAR UNA TAREA//
    if(actualObj == 1 && actualType == 1)
    {
      //NOMBRE//
      if(actualProcess == 1)
      {
        NewTask.name = _text;
        _voice.speak("¿Cual es la descripción de la tarea?");
        _stext = "¿Cual es la descripción de la tarea?";
        _text = "¿Cual es la descripción de la tarea?";
        actualProcess++;
      }
      //DESCRIPCION//
      else if(actualProcess == 2)
      {
        NewTask.description = _text;
        _voice.speak("¿Cual es la fecha de entrega de la tarea?");
        _voice.speak("Se claro con la fecha, especifica dia y mes.");
        _stext = "¿Cual es la fecha de entrega de la tarea? (Se claro con la fecha, especifica dia y mes)";
        actualProcess++;
      }
      //FECHA//
      else if(actualProcess == 3)
      {
        List<String> words = [];
        int cont = _text.length;
        String actualWord="";
        //SEPARAR POR PALABRAS//
        for (var i=0; i<cont; i++)
        {
          if(_text[i]==" "||i==cont-1)
          {
            if(i==cont-1)
            {
              actualWord+=_text[i];
            }
            words.add(actualWord.toUpperCase());
            actualWord="";
          }
          else
          {
            actualWord+=_text[i];
          }
        }
        createDate(words);
        _voice.speak("¿De que materia?");
        _stext = "¿De que materia?";
        actualProcess++;
      }
      //MATERIA//
      else if(actualProcess == 4)
      {
        //VALIDAR SI EL USUARIO TIENE UNA MATERIA CON ESE NOMBRE//
        String validSubject = "";
        for(int i=0; i<_text.length; i++)
        {
          if(i==0)
          {
            validSubject+=_text[i].toUpperCase();
          }
          else
          {
            validSubject+=_text[i];
          }
        }
        List<Subject?> ActualSubject = await subject_provider.getByName(validSubject, userSession.id.toString());
        if(ActualSubject.length==0)
        {
          _voice.speak("Lo siento, no tienes una materia registrada con ese nombre, intenta con otra o verifica su ortografia.");
          _stext = "¿De que materia?";
        }
        else
        {
          NewTask.subject = validSubject;
          _voice.speak("¿Es de tipo Examen, Tarea o Actividad?");
          _stext = "¿Es de tipo Examen, Tarea o Actividad?";
          actualProcess++;
        }
      }
      //TIPO//
      else if(actualProcess == 5)
      {
        String isValidType = _text.toUpperCase();
        if(isValidType == "EXAMEN" || isValidType == "TAREA" || isValidType == "ACTIVIDAD")
        {
          if(isValidType == "EXAMEN")
          {
            NewTask.type="Examen";
          }
          else if(isValidType == "ACTIVIDAD")
          {
            NewTask.type="Actividad";
          }
          else
          {
            NewTask.type="Tarea";
          }
          actualProcess++;
          _voice.speak("A continuación, te muestro la información de la tarea, si es correcta di Guardar para registrarla o Cancelar para descartarla.");
          _stext = "El Nombre es: "+NewTask.name.toString() + "\nLa Descripción es: "+NewTask.description.toString()+"\nLa Fecha es: "+NewTask.deliveryDate.toString()
                + "\nLa Materia es: "+NewTask.subject.toString() + "\nEl Tipo es: "+NewTask.type.toString();
        }
        else
        {
          _voice.speak("Lo siento, solo puede ser Examen, Tarea o Actividad");
          _stext = "¿Es de tipo Examen, Tarea o Actividad?";
        }
      }
      //CONFIRMAR//
      else if(actualProcess == 6)
      {
        if(_text.toUpperCase() == "GUARDAR")
        {
          NewTask.status="PENDIENTE";
          _voice.speak("Se guardó la tarea");
          task_provider.create(NewTask);
          _stext = "¿En que puedo ayudarte?";
          resetIA();
        }
        else if(_text.toUpperCase() == "CANCELAR")
        {
          _voice.speak("Se ha descartado la tarea");
          _stext = "¿En que puedo ayudarte?";
          NewTask = new Task();
          resetIA();
        }
        else
        {
          _voice.speak("Solo son validas las opciones Guardar o Cancelar.");
          _stext = "El Nombre es: "+NewTask.name.toString() + "\nLa Descripcion es: "+NewTask.description.toString()+"\nLa Fecha es: "+NewTask.deliveryDate.toString()
                 + "\nLa Materia es: "+NewTask.subject.toString() + "\nEl Tipo es: "+NewTask.type.toString();
        }
      }
    }
    //ELIMINAR UNA TAREA//
    else if(actualObj == 1 && actualType == 3)
    {
      //ELIMINAR LA TAREA POR NOMBRE//
        if(actualProcess==1)
        {
          NewTask.name = _text.toUpperCase();
          debugPrint(NewTask.name);
          List<Task?> searchTask = await task_provider.getByUserAndName(userSession.id.toString(),NewTask.name.toString());
          if(searchTask.length!=0)
          {
            taskDb = searchTask[0];
            String? subjectName = taskDb?.name.toString();
            _voice.speak("Existe la tarea, ¿Estas seguro de que quieres eliminarla?"); 
            _stext = "Se eliminara la Tarea: "+ subjectName!;
            actualProcess=2;
          }
          else
          {
            _voice.speak("Lo siento, no existe esa Tarea, intenta con otra.");
            _stext = "¿En que puedo ayudarte?";
            resetIA();
          }  
        }
        //CONFIRMACION
        else if(actualProcess==2)
        {
          if(_text.toUpperCase() == "SÍ")
          {
            task_provider.deleteTask(taskDb?.id);
            _voice.speak("Tarea eliminada exitosamente");
            _stext = "¿En que puedo ayudarte?";
            resetIA();
          }
          else if(_text.toUpperCase() == "NO")
          {
            _voice.speak("No se eliminara la Tarea.");
            _stext = "¿En que puedo ayudarte?";
            resetIA();
          }
          else
          {
            _voice.speak("Lo siento, utiliza Si, para confirmar y No, para cancelar");
          } 
        }
    }
    //INSERTAR UNA MATERIA//
    else if(actualObj == 2 && actualType == 1)
    {
      //NOMBRE//
      if(actualProcess == 1)
      {
        NewSubject.name = _text;
        _voice.speak("¿Cual es el codigo de la materia?");
        _stext = "¿Cual es el codigo de la materia?";
        _text = "¿Cual es el codigo de la materia?";
        actualProcess++;
      }
      //CODIGO DE LA MATERIA//
      else if(actualProcess == 2)
      {
        NewSubject.subject_code = _text;
        _voice.speak("¿Cual es el nombre del profesor?");
        _stext = "¿Cual es el nombre del profesor?";
        actualProcess++;
      }
      //NOMBRE DEL PROFESOR//
      else if(actualProcess == 3)
      {
        NewSubject.professor_name = _text;
        _voice.speak("A continuación, te muestro la información de la materia, si es correcta di Guardar para registrarla o Cancelar para descartarla.");
        _stext = "El Nombre es: "+NewSubject.name.toString() + "\nEl Codigo de la Materia es: "+NewSubject.subject_code.toString()+"\nLa Fecha es: "+NewSubject.professor_name.toString();
        actualProcess++;
      }
      //CONFIRMAR//
      else if(actualProcess == 4)
      {
        if(_text.toUpperCase() == "GUARDAR")
        {
          _voice.speak("Se guardó la Materia");
          subject_provider.create(NewSubject);
          _stext = "¿En que puedo ayudarte?";
          resetIA();
        }
        else if(_text.toUpperCase() == "CANCELAR")
        {
          _voice.speak("Se ha descartado la tarea");
          _stext = "¿En que puedo ayudarte?";
          NewSubject = new Subject();
          resetIA();
        }
        else
        {
          _voice.speak("Solo son validas las opciones Guardar o Cancelar.");
          _stext = "El Nombre es: "+NewSubject.name.toString() + "\nEl Codigo de la Materia es: "+NewSubject.subject_code.toString()+"\nLa Fecha es: "+NewSubject.professor_name.toString();
        }
      }
    }
  }





  //FUNCION PARA GENERAR UNA FECHA SEGUN EL TEXTO INGRESADO//
  bool createDate(List<String> words)
  {
    String day = "", month = "";
    for(var i=0; i<words.length; i++)
    {
      if(int.tryParse(words[i])!=null)
      {
        day = int.tryParse(words[i]).toString();
      }
      else if(words[i]=="PRIMERO") { day = "01"; }
      else if(words[i]=="ENERO") { month = "01"; }
      else if(words[i]=="FEBERO") { month = "02"; }
      else if(words[i]=="MARZO") { month = "03"; }
      else if(words[i]=="ABRIL") { month = "04"; }
      else if(words[i]=="MAYO") { month = "05"; }
      else if(words[i]=="JUNIO") { month = "06"; }
      else if(words[i]=="JULIO") { month = "07"; }
      else if(words[i]=="AGOSTO") { month = "08"; }
      else if(words[i]=="SEPTIEMBRE") { month = "09"; }
      else if(words[i]=="OCTUBRE") { month = "10"; }
      else if(words[i]=="NOVIEMBRE") { month = "11"; }
      else if(words[i]=="DICIEMBRE") { month = "12"; }      
    }
    if(day == "" || month == "")
    {
      return false;
    }
    else
    {
      var now = new DateTime.now();
      DateTime fecha = new DateTime(now.year,int.parse(month),int.parse(day));
      String NewDate = day + "-"+month+"-"+now.year.toString()+" 00:00:00";
      NewTask.deliveryDate= fecha.toString();
      debugPrint(fecha.toString());
      return true;
    }
  }
  // ---------------------------------------------------------------------------------------- //


}