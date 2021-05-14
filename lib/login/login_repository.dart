import 'package:dio/dio.dart';

import '../utils/custom_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  Future<bool> login(String email, String senha) async {
    var dio = CustomDio().instancia;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('app-pilates-email', email);
    await prefs.setString('app-pilates-senha', senha);

    try {
      var res = await dio.post('usuario/login', data: {
        'email': email,
        'senha': senha
      });
      await prefs.setString('app-pilates-token', res.data['token']);
      return true;
    } on DioError catch (e) {
      if ((e.response != null) && (e.response!.data != null) && (e.response!.data['mensagem'] != null))
        throw Exception('Erro: '+e.response!.data['mensagem']);
      else
        throw Exception('Erro: '+e.message);
    }
  }

  Future<String> loginComPreferences() async {
    var dio = CustomDio().instancia;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.containsKey('app-pilates-email') ? prefs.getString('app-pilates-email') : '';
    var senha = prefs.containsKey('app-pilates-senha') ? prefs.getString('app-pilates-senha') : '';

    try {
      var res = await dio.post('usuario/login', data: {
        'email': email,
        'senha': senha
      });
      await prefs.setString('app-pilates-token', res.data['token']);
      return Future.value(res.data['token'].toString());
    } on DioError catch (e) {
      if ((e.response != null) && (e.response!.data != null) && (e.response!.data['mensagem'] != null))
        throw Exception('Erro: '+e.response!.data['mensagem']);
      else
        throw Exception('Erro: '+e.message);
    }    
  }  
}