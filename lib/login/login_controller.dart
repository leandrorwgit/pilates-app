import 'package:rx_notifier/rx_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../utils/rotas.dart';
import 'login_repository.dart';

class LoginController {
  final _repository = LoginRepository();
  final emailController = TextEditingController(text: '');
  final senhaController = TextEditingController(text: '');
  var carregando = RxNotifier<int>(0);

  Future<void> buscarDadosPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = (prefs.containsKey('app-pilates-email') ? prefs.getString('app-pilates-email') : '')!;
    senhaController.text = (prefs.containsKey('app-pilates-senha') ? prefs.getString('app-pilates-senha') : '')!;
  }

  Future<void> login(BuildContext context) async {
    try {
      carregando.value = 1;
      bool loginOk =
          await _repository.login(emailController.text, senhaController.text);
      if (loginOk)
        Navigator.of(context).pushReplacementNamed(Rotas.PRINCIPAL);
      else
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email/Senha incorretos.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))));
    } finally {
      carregando.value = 0;
    }
  }

  void dispose() {
    emailController.dispose();
    senhaController.dispose();
  }
}
