import '../utils/rotas.dart';
import 'package:flutter/material.dart';

class LoginController {
  final emailController = TextEditingController(text: '');
  final senhaController = TextEditingController(text: '');
  final carregando = false;

  void login(BuildContext context) {
    if (emailController.text == 'teste')
      Navigator.of(context).pushReplacementNamed(Rotas.PRINCIPAL);
  }

  void dispose() {
    emailController.dispose();
    senhaController.dispose();
  }
}