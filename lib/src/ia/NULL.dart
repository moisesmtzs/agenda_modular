import 'dart:ffi';

import 'package:agenda_app/src/models/ia_task.dart';
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/providers/ia_taskProvider.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agenda_app/src/ia/text_to_speech.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:get/get.dart';
import 'package:agenda_app/src/models/user.dart';

import '../providers/tasksProvider.dart';

class Command_Controller
{
  //ATRIBUTOS//
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  stt.SpeechToText _speech = stt.SpeechToText(); //ENCARGADO DE ESCUCHAR//
  bool _isListening = false; //BOOLEANO QUE DETERMIAN EL ESTADO DE LA VOZ//
  String _text = "¿En que puedo ayudarte?"; //MENSAJE A ANALIZAR//
  String _stext = "¿En que puedo ayudarte?"; //MENSAJE AL USUARIO//
  double _confidence = 1.0; //CONFIABILIDAD//
  VoiceRosalind _voice = new VoiceRosalind();

  //PROVIDERS//
  final ia_taskProvider ia_provider =  Get.put(ia_taskProvider());
  final SubjectProvider subject_provider =  Get.put(SubjectProvider());
  final TasksProvider task_provider =  Get.put(TasksProvider());

  //BANDERAS DE ACCION//
  //TAREAS//
  int isNewTask = 0;
  int deleteTask = 0;
  Task? taskDb;

  //OBJETOS CON LOS QUE TRABAJARA LA IA//
  Task NewTask = new Task();

  //CONSTRUCTOR//
  Command_Controller() {
    _speech = stt.SpeechToText();
    _voice = new VoiceRosalind();
  }

  //FUNCION PARA HABLAR//
  void speakRosalind(String TextSpeak) async {
    _text = TextSpeak;
    //VALIDAR PALABRAS ANTISONANTES//
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

      //SE ESTA AGREGANDO UNA TAREA//
      if(isNewTask!=0)
      {
        //NOMBRE//
        if(isNewTask == 1)
        {
          NewTask.name = _text;
          _voice.speak("¿Cual es la descripción de la tarea?");
          _stext = "¿Cual es la descripción de la tarea?";
          _text = "¿Cual es la descripción de la tarea?";
          isNewTask = 2;
        }
        //DESCRIPCION//
        else if(isNewTask==2)
        {
          NewTask.description = _text;
          _voice.speak("¿Cual es la fecha de entrega de la tarea?");
          _voice.speak("Se claro con la fecha, especifica dia y mes.");
          _stext = "¿Cual es la fecha de entrega de la tarea? (Se claro con la fecha, especifica dia y mes)";
          isNewTask = 3;
        }
        //FECHA//
        else if(isNewTask==3)
        {
          createDate(words);
          _voice.speak("¿De que materia?");
          _stext = "¿De que materia?";
          isNewTask = 4;
        }
        //MATERIA//
        else if(isNewTask==4)
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
            isNewTask = 5;
          }
        }
        //TIPO//
        else if(isNewTask==5)
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
            isNewTask = 6;
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
        else if(isNewTask==6)
        {
          if(_text.toUpperCase() == "GUARDAR")
          {
            NewTask.status="PENDIENTE";
            _voice.speak("Se guardó la tarea");
            task_provider.create(NewTask);
            _stext = "¿En que puedo ayudarte?";
            isNewTask = 0;
          }
          else if(_text.toUpperCase() == "CANCELAR")
          {
            _voice.speak("Se ha descartado la tarea");
            _stext = "¿En que puedo ayudarte?";
            NewTask = new Task();
            isNewTask=0;
          }
          else
          {
            _voice.speak("Solo son validas las opciones Guardar o Cancelar.");
            _stext = "El Nombre es: "+NewTask.name.toString() + "\nLa Descripcion es: "+NewTask.description.toString()+"\nLa Fecha es: "+NewTask.deliveryDate.toString()
                  + "\nLa Materia es: "+NewTask.subject.toString() + "\nEl Tipo es: "+NewTask.type.toString();
          }
        }
      }
      //ELIMINAR TAREA POR NOMBRE//
      else if(deleteTask!=0)
      {
        //ELIMINAR LA TAREA POR NOMBRE//
        if(deleteTask==1)
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
            deleteTask=2;
          }
          else
          {
            _voice.speak("Lo siento, no existe esa Tarea, intenta con otra.");
            _stext = "¿En que puedo ayudarte?";
            deleteTask=0;
          }  
        }
        //CONFIRMACION
        else if(deleteTask==2)
        {
          if(_text.toUpperCase() == "SÍ")
          {
            task_provider.deleteTask(taskDb?.id);
            _voice.speak("Tarea eliminada exitosamente");
            _stext = "¿En que puedo ayudarte?";
            deleteTask=0;
          }
          else if(_text.toUpperCase() == "NO")
          {
            _voice.speak("No se eliminara la Tarea.");
            _stext = "¿En que puedo ayudarte?";
            deleteTask=0;
          }
          else
          {
            _voice.speak("Lo siento, utiliza Si, para confirmar y No, para cancelar");
          } 
        }
      }
      else
      {
        // -- PRINT DEBUG -- //
        debugPrint("La cantidad de palabras es: "+words.length.toString());
        debugPrint("PALABRAS: "+words.toString());

        //RECORRER TODAS LAS PALABRAS DETECTADAS//
        List<ia_task?> bd_list = await ia_provider.getAll();
        List<ia_task?> instruction = [];
        for(var i=0; i<words.length; i++)
        {
          //BUSCA LA PALABRA ACTUAL//
          List<ia_task?> bd_exist = await ia_provider.getByCommand(words[i]);
          //SI EXISTE UNA PALABRA ALMACENADA EN LA BD//
          if(bd_exist.length>0)
          {
            debugPrint(bd_exist[0]?.command.toString());
            instruction.add(bd_exist[0]);
          }
        }
        //SI NO EXISTEN INSTRUCCIONES CON ESAS PALABRAS//
        if(instruction.length==0)
        {
          _voice.speak("Lo siento, no conozco ese comando.");
          _stext = "¿En que puedo ayudarte?";
        }
        else
        {
          //SI CONTIENE UN NUMERO DIFERENTE DE 2 PALABRAS CLAVES//
          if(instruction.length!=2)
          {
            _voice.speak("Lo siento, el comando no es claro.");
            _stext = "¿En que puedo ayudarte?";
          }
          else
          {
            //ES UNA TAREA//
            if(instruction[0]?.obj=="TAREA" || instruction[1]?.obj=="TAREA")
            {
              if(instruction[0]?.obj=="INSERTAR" || instruction[1]?.obj=="INSERTAR")
              {
                //INSERTAR//
                isNewTask=1;
                NewTask = new Task();
                NewTask.idUser = userSession.id;    
                _voice.speak("¿Cual es el nombre de la tarea?");
                _stext = "¿Cual es el nombre de la tarea?";
              }
              else if(instruction[0]?.obj=="ELIMINAR" || instruction[1]?.obj=="ELIMINAR")
              {
                //ELIMINAR//
                deleteTask=1;
                NewTask = new Task();
                NewTask.idUser = userSession.id; 
                _voice.speak("¿Cual es el nombre de la tarea?");
                _stext = "¿Cual es el nombre de la tarea?";
              }
              //EDITAR//

            }
          }
          
        }       
      }
    } 
    else
    {
      _voice.speak("Lo siento, no estan permitidas palabras antisonantes. Intenta de Nuevo");
      _stext = "¿En que puedo ayudarte?";
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

  //ANALIZAR TEXTO//
  bool badwords() 
  {
    int contador = 0, sizeText = _text.length;
    //CONTAR CUANTOS * EXISTEN//
    for (var i = 0; i < sizeText; i++)
    {
      if(_text[i]=='*')
      {
        contador+=1;
      }
    }
    //SI ES MAYOR QUE UNO ES UNA PALABRA ANTISONANTE//
    if(contador > 0)
    {
      return false;
    }
    //SINO ES VALIDA//
    else
    {
      return true;
    }
  }

  //FUNCION PARA DEJAR DE ESCUCHAR//
  void stopListening() {
    _speech.stop();
  }

  //REINICIAR TEXT//
  void resetText()
  {
    _stext = "¿En que puedo ayudarte?";
    _text = "¿En que puedo ayudarte?";
  }

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

  

}