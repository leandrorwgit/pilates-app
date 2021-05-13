import '../utils/custom_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  Future<bool> login(String email, String senha) async {
    var dio = CustomDio().instancia;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('app-pilates-email', email);
    await prefs.setString('app-pilates-senha', senha);

    return dio.post('usuario/login', data: {
      'email': email,
      'senha': senha
    }).then((res) async {
      await prefs.setString('app-pilates-token', res.data['token']);
      return true;
    }).catchError((err) {
      throw Exception('Login ou senha inválidos');
    });
  }

  Future<String> loginComPreferences() async {
    var dio = CustomDio().instancia;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.containsKey('app-pilates-email') ? prefs.getString('app-pilates-email') : '';
    var senha = prefs.containsKey('app-pilates-senha') ? prefs.getString('app-pilates-senha') : '';

    return dio.post('usuario/login', data: {
      'email': email,
      'senha': senha
    }).then((res) async {
      await prefs.setString('app-pilates-token', res.data['token']);
      return Future.value(res.data['token'].toString());
    }).catchError((err) {
      throw Exception('Login ou senha inválidos');
    });
  }  
}