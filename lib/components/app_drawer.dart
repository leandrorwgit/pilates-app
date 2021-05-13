import 'package:app_pilates/utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/rotas.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  Widget _criarItem(IconData icone, String descricao, Function onTap) {
    return ListTile(
      leading: Icon(
        icone,
        size: 26,
        color: AppColors.texto,
      ),
      title: Text(
        descricao,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.texto,
        ),
      ),
      onTap: onTap as void Function()?,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            width: double.infinity,
            padding: EdgeInsets.only(top: 30),
            color: AppColors.background,
            child: Column(
              children: [
                Container(
                  height: 120,
                  child: Image.asset('assets/images/logo-pilates.png'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _criarItem(
            Icons.home,
            'Principal',
            () => Navigator.of(context).pushReplacementNamed(Rotas.PRINCIPAL),
          ),
          _criarItem(
            Icons.calendar_today,
            'Agenda',
            () => Navigator.of(context).pushReplacementNamed(Rotas.AGENDA),
          ),
          _criarItem(
            Icons.person,
            'Alunos',
            () => Navigator.of(context).pushReplacementNamed(Rotas.ALUNO_LISTA),
          ),
          _criarItem(
            Icons.trending_up,
            'Evoluções',
            () => Navigator.of(context).pushReplacementNamed(Rotas.EVOLUCAO_LISTA),
          ),
          _criarItem(
            Icons.exit_to_app,
            'Sair',
            () => deslogarApp(context),
          ),
        ],
      ),
    );
  }

  Future<void> deslogarApp(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('app-pilates-token');
    prefs.remove('app-pilates-senha');
    Navigator.of(context).pushReplacementNamed(Rotas.LOGIN);
    //SystemChannels.platform.invokeMethod('SystemNavigator.pop')
  }
}
