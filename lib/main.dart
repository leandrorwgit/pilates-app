import 'agenda/agenda_view.dart';
import 'agendamento/agendamento_form_view.dart';
import 'agendamento/agendamento_lista_view.dart';
import 'agendamento/reagendamento_form_view.dart';
import 'evolucao/evolucao_form_view.dart';
import 'evolucao/evolucao_lista_view.dart';
import 'models/agenda_retorno.dart';
import 'models/agendamento.dart';
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
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
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
        Rotas.AGENDAMENTO_LISTA: (ctx) => AgendamentoListaView(),
        Rotas.AGENDAMENTO_FORM: (ctx) => AgendamentoFormView(
            agendamento: ModalRoute.of(ctx)!.settings.arguments != null
                ? ModalRoute.of(ctx)!.settings.arguments as Agendamento
                : null),
        Rotas.REAGENDAMENTO_FORM: (ctx) => 
          ReAgendamentoFormView(
            agendaRetorno: ModalRoute.of(ctx)!.settings.arguments != null
                ? ModalRoute.of(ctx)!.settings.arguments as AgendaRetorno
                : null),
      },
    );
  }
}
