import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../agendamento/agendamento_repository.dart';
import '../models/agendamento.dart';
import '../models/aluno.dart';
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
  late final _repositoryAgendamento;
  final DateTime date = DateTime.now();
  late Future<List<AgendaRetorno>> _listaAgendaFuture;
  var carregando = RxNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _repository = AgendaRepository();
    _repositoryAluno = AlunoRepository();
    _repositoryEvolucao = EvolucaoRepository();
    _repositoryAgendamento = AgendamentoRepository();
    carregarListaAgenda();
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
                  // onHoursColumnTappedDown: (HourMinute hourMinute) {
                  //   print(hourMinute);
                  // },
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
                      title:
                          (agendaRetorno.tipo == 'AGENDAMENTO' ? 'AG: ' : '') +
                              (agendaRetorno.descricao ?? ''),
                      description: '',
                      start: dataHoraIni,
                      end: dataHoraFim,
                      backgroundColor: corEvento,
                      margin: EdgeInsets.all(1),
                      padding: EdgeInsets.all(5),
                      onLongPress: () async {
                        if (agendaRetorno.tipo == 'AGENDAMENTO') {
                          Agendamento agendamento;
                          try {
                            carregando.value = true;
                            agendamento = await _repositoryAgendamento.buscar(agendaRetorno.idAgendamento);
                          } finally {
                            carregando.value = false;
                          }
                          _abrirFormularioAgendamento(agendamento, null);                                          
                        } else {
                          _abrirDialogOpcoes(agendaRetorno);
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
                            carregarListaAgenda();
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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            _abrirFormularioAgendamento(null, null);
          }),
    );
  }

  void carregarListaAgenda() {
    _listaAgendaFuture = _repository.buscar(DateTime.now());
  }

  Future<void> _abrirEdicaoAluno(int? idAluno) async {
    Aluno aluno;
    try {
      carregando.value = true;
      aluno = await _repositoryAluno.buscar(idAluno);
    } finally {
      carregando.value = false;
    }
    final result = await Navigator.of(context)
        .pushNamed(Rotas.ALUNO_FORM, arguments: aluno);
    if (result != null) {
      // Se retornou é porque criou/alterou, então atualiza busca
      setState(() {
        carregarListaAgenda();
      });
    }
  }

  void _abrirDialogOpcoes(AgendaRetorno agendaRetorno) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Opções', style: TextStyle(color: AppColors.label)),
          backgroundColor: AppColors.background,
          actions: <Widget>[
            TextButton(
              child: Text('Reagendar', style: TextStyle(color: AppColors.texto)),
              onPressed: () async {
                await _abrirFormularioAgendamento(null, agendaRetorno);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Editar aluno', style: TextStyle(color: AppColors.label)),
              onPressed: () {
                _abrirEdicaoAluno(agendaRetorno.idAluno);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );    
  }

  Future<void> _abrirFormularioAgendamento(Agendamento? agendamento, AgendaRetorno? agendaRetornoReagendar) async {
    final result;
    if (agendaRetornoReagendar != null) {
      result = await Navigator.of(context).pushNamed(Rotas.REAGENDAMENTO_FORM, arguments: agendaRetornoReagendar);
    } else {
      result = await Navigator.of(context).pushNamed(Rotas.AGENDAMENTO_FORM, arguments: agendamento);
    }
    if (result != null) {
      // Se retornou um registro é porque alterou, então atualiza busca
      setState(() {
        carregarListaAgenda();
      });
    }
  }
}
