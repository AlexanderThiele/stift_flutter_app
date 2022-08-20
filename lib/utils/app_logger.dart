class AppLogger {
  static d(dynamic msg){
    print(msg);
  }
  static e(dynamic msg, {Exception? e}){
    print(msg);
  }
}