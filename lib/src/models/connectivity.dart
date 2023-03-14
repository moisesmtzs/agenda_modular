import 'dart:io';

class Connect {

  bool? isConnected;

  Connect() {
    isConnected = false;
    getConnectivity();
  }

  void getConnectivity() async {
    
    try { 
      final result = await InternetAddress.lookup('google.com'); 
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) { 
        print('CONECTADO'); 
        isConnected = true;
      }
    } on SocketException catch (_) { 
      print('SIN CONEXION'); 
      isConnected = false;
    }  
  }

}