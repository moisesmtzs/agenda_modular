import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:get_storage/get_storage.dart';
import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/ia_task.dart';

class ia_taskProvider extends GetConnect 
{
  String url = Environment.API_URL + "api/iatasks";

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<ia_task?>> getAll() async {

    try {
      Uri _url = Uri.http(Environment.API_URL_OLD, '/api/ia/getAll');
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };
      final res = await http.get(_url, headers: headers);

      final data = json.decode(res.body);
      ia_task task = ia_task.fromJsonList(data);
      return task.toList;

    } catch (e) {
      return [];
    }
  }

  Future<List<ia_task?>> getByWord(String word) async {

    try {
      Uri _url = Uri.http(Environment.API_URL_OLD, '/api/ia/findByWord/$word');
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };
      final res = await http.get(_url, headers: headers);

      final data = json.decode(res.body);
      ia_task task = ia_task.fromJsonList(data);
      return task.toList;

    } catch (e) {
      e.printError();
      return [];
    }

  }
}