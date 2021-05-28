import 'package:app_pilates/models/aluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../aluno/aluno_repository.dart';
import '../components/app_drawer.dart';
import '../evolucao/evolucao_repository.dart';
import '../models/agenda_retorno.dart';
import '../models/evolucao.dart';
import '../utils/app_colors.dart';
import '../utils/componentes.dart';
import '../utils/formatos.dart';
import '../utils/rotas.dart';

import 'agenda_repository.dart';

class AgendaView extends StatefulWidget {
  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  late final _repository;
  late final _repositoryAluno;
  late final _repositoryEvolucao;
  final DateTime date = DateTime.now();
  late Future<List<AgendaRetorno>> _listaAgendaFuture;
  var carregando = RxNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _repository = AgendaRepository();
    _repositoryAluno = AlunoRepository();
    _repositoryEvolucao = EvolucaoRepository();
    _listaAgendaFuture = _repository.buscar(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
      ),
      drawer: AppDrawer(),
      body: Stack(children: [
        FutureBuilder(
            future: this._listaAgendaFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<AgendaRetorno>> snapshot) {
              if (snapshot.hasError) {
                return Componentes.erroRest(snapshot);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return WeekView(
                  initialTime: DateTime.now(),
                  dates: [
                    date.subtract(const Duration(days: 1)),
                    date,
                    date.add(const Duration(days: 1))
                  ],
                  events: snapshot.data!.map((agendaRetorno) {
                    DateTime dataHoraIni = Formatos.dataYMDHora.parse(
                        agendaRetorno.dia! + ' ' + agendaRetorno.horaIni!);
                    DateTime dataHoraFim = Formatos.dataYMDHora.parse(
                        agendaRetorno.dia! + ' ' + agendaRetorno.horaFim!);
                    Color corEvento = Theme.of(context).accentColor;
                    if (agendaRetorno.idEvolucao != null) {
                      corEvento = AppColors.darkGreen;
                    } else if (DateTime.now().isAfter(dataHoraFim)) {
                      corEvento = AppColors.darkRed;
                    }

                    return FlutterWeekViewEvent(
                      title: agendaRetorno.descricao ?? '',
                      description: '',
                      start: dataHoraIni,
                      end: dataHoraFim,
                      backgroundColor: corEvento,
                      margin: EdgeInsets.all(1),
                      padding: EdgeInsets.all(5),
                      onLongPress: () async {
                        Aluno aluno;
                        try {
                          carregando.value = true;
                          aluno = await _repositoryAluno.buscar(agendaRetorno.idAluno);
                        } finally {
                          carregando.value = false;
                        }
                        final result = await Navigator.of(context).pushNamed(
                            Rotas.ALUNO_FORM, arguments: aluno);
                        if (result != null) {
                          // Se retornou é porque criou/alterou, então atualiza busca
                          setState(() {
                            _listaAgendaFuture =
                                _repository.buscar(DateTime.now());
                          });
                        }
                      },
                      onTap: () async {
                        Evolucao evolucao;
                        try {
                          carregando.value = true;
                          if (agendaRetorno.idEvolucao != null) {
                            evolucao = await _repositoryEvolucao
                                .buscar(agendaRetorno.idEvolucao);
                          } else {
                            evolucao = Evolucao();
                            evolucao.data = dataHoraFim;
                            evolucao.aluno = await _repositoryAluno
                                .buscar(agendaRetorno.idAluno);
                          }
                        } finally {
                          carregando.value = false;
                        }
                        final result = await Navigator.of(context).pushNamed(
                            Rotas.EVOLUCAO_FORM,
                            arguments: evolucao);
                        if (result != null) {
                          // Se retornou é porque criou/alterou, então atualiza busca
                          setState(() {
                            _listaAgendaFuture =
                                _repository.buscar(DateTime.now());
                          });
                        }
                      },
                      eventTextBuilder: (FlutterWeekViewEvent event,
                          BuildContext context,
                          DayView dayView,
                          double height,
                          double width) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.texto,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  dayView.hoursColumnStyle.timeFormatter(
                                          HourMinute.fromDateTime(
                                              dateTime: event.start)) +
                                      ' - ' +
                                      dayView.hoursColumnStyle.timeFormatter(
                                          HourMinute.fromDateTime(
                                              dateTime: event.end)),
                                  style: TextStyle(color: AppColors.texto))
                            ]);
                      },
                    );
                  }).toList(),
                  dayViewStyleBuilder: (DateTime date) =>
                      DayViewStyle.fromDate(date: date).copyWith(
                          backgroundColor: AppColors.background,
                          backgroundRulesColor: Colors.black),
                  dayBarStyleBuilder: (DateTime date) =>
                      DayBarStyle.fromDate(date: date).copyWith(
                          color: Colors.black45,
                          textStyle: TextStyle(color: AppColors.texto),
                          dateFormatter: (int year, int month, int day) =>
                              Formatos.adicionaZeroEsquerda(day) +
                              '/' +
                              Formatos.adicionaZeroEsquerda(month) +
                              '/' +
                              year.toString()),
                  hoursColumnStyle: HoursColumnStyle().copyWith(
                    color: Colors.black45,
                    textStyle: TextStyle(color: AppColors.texto),
                  ),
                );
              }
            }),
        // Loading
        Positioned(
          child: RxBuilder(builder: (_) {
            return carregando.value
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    color: Colors.white.withOpacity(0.1),
                  )
                : Container();
          }),
        )
      ]),
    );
  }
}
