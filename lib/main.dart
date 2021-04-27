import 'agenda/agenda_view.dart';
import 'evolucao/evolucao_form_view.dart';
import 'evolucao/evolucao_lista_view.dart';
import 'models/aluno.dart';

import 'aluno/aluno_form_view.dart';
import 'aluno/aluno_lista_view.dart';

import 'models/evolucao.dart';
import 'utils/app_colors.dart';

import 'utils/rotas.dart';

import 'login/login_view.dart';
import 'principal_view.dart';
import 'package:flutter/material.dart';
import 'package:material_color_scheme/material_color_scheme.dart';

void main() {
  runApp(AppPilates());
}

class AppPilates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pilates',
      theme: ThemeData(
        primarySwatch: generateSwatch(Colors.purple[700]!),
        canvasColor: AppColors.background,
      ),
      initialRoute: Rotas.LOGIN,
      routes: {
        Rotas.LOGIN: (ctx) => LoginView(),
        Rotas.PRINCIPAL: (ctx) => PrincipalView(),
        Rotas.AGENDA: (ctx) => AgendaView(),
        Rotas.ALUNO_LISTA: (ctx) => AlunoListaView(),
        Rotas.ALUNO_FORM: (ctx) => AlunoFormView(
            aluno: ModalRoute.of(ctx)!.settings.arguments != null
                ? ModalRoute.of(ctx)!.settings.arguments as Aluno
                : null),
        Rotas.EVOLUCAO_LISTA: (ctx) => EvolucaoListaView(),
        Rotas.EVOLUCAO_FORM: (ctx) => EvolucaoFormView(
            evolucao: ModalRoute.of(ctx)!.settings.arguments != null
                ? ModalRoute.of(ctx)!.settings.arguments as Evolucao
                : null),
      },
    );
  }
}
