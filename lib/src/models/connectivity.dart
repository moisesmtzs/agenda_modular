import 'dart:io';

import '../api/db.dart';

class Connect {

  bool? isConnected;

  Connect() {
    getConnectivity();
  }

  Future getConnectivity() async {
    try { 
      final result = await InternetAddress.lookup('google.com'); 
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) { 
        print('CONECTADO'); 
        isConnected = true;
      } else {
        isConnected = false;
      }
    } on SocketException catch (_) { 
      print('SIN CONEXION'); 
      isConnected = false;
    }  
  }

  Future getConnectivityReplica() async {
    try { 
      final result = await InternetAddress.lookup('google.com'); 
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) { 
        createSync();
      } else {
        print('NO HAY CONEXION DISPONIBLE PARA REALIZAR UNA REPLICA'); 
        isConnected = false;
      }
    } on SocketException catch (_) { 
      print('SIN CONEXION REPLICA'); 
      isConnected = false;
    }  
  }

}