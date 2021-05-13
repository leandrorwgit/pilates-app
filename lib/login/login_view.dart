import 'package:rx_notifier/rx_notifier.dart';

import 'login_controller.dart';
import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginController();
    controller.buscarDadosPreferencias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 180,
                  child: Image.asset('assets/images/logo-pilates.png'),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: controller.emailController,
                  style: TextStyle(color: AppColors.texto),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.label),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.label,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: controller.senhaController,
                  obscureText: true,
                  style: TextStyle(color: AppColors.texto),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: AppColors.label),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.label,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RxBuilder(builder: (_) {
                  return controller.carregando.value == 1
                      ? CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            child: Text('ENTRAR'),
                            onPressed: () => controller.login(context),
                          ),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
