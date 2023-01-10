import 'dart:developer';

class AppLogger {
  static d(dynamic msg){
    log(msg);
  }
  static e(dynamic msg, {Exception? e}){
    log(msg);
  }
}