import 'dart:convert';

import 'ia_task.dart';

class command {
  int? simil;
  ia_task? task;

  command()
  {
    this.simil;
    this.task;
  }

  // ------------------------------------SETTERS|GETTERS------------------------------------ //

  //GETTERS//
  ia_task? getTask()
  {
    return task;
  }

  int? getSimil()
  {
    return simil;
  }

  //SETTERS//
  void setTask(ia_task newTask)
  {
    task = newTask;
  }

  void setSimil(int newSimil)
  {
    simil = newSimil;
  }

  // ---------------------------------------------------------------------------------------- //



}
