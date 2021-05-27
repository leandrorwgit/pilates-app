import 'package:app_pilates/components/app_drawer.dart';
import 'package:app_pilates/models/agenda_retorno.dart';
import 'package:app_pilates/utils/app_colors.dart';
import 'package:app_pilates/utils/componentes.dart';
import 'package:app_pilates/utils/formatos.dart';
import 'package:app_pilates/utils/rotas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

import 'agenda_repository.dart';

class AgendaView extends StatefulWidget {
  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  late final _repository;
  final DateTime date = DateTime.now();
  late Future<List<AgendaRetorno>> _listaAgendaFuture;

  @override
  void initState() {
    super.initState();
    _repository = AgendaRepository();
    _listaAgendaFuture = _repository.buscar(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
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
                  return FlutterWeekViewEvent(
                    title: agendaRetorno.descricao ?? '',
                    description: '',
                    start: Formatos.dataYMDHora.parse(
                        agendaRetorno.dia! + ' ' + agendaRetorno.horaini!),
                    end: Formatos.dataYMDHora.parse(
                        agendaRetorno.dia! + ' ' + agendaRetorno.horafim!),
                    backgroundColor: Theme.of(context).accentColor,
                    //backgroundColor: Theme.of(context).errorColor, // Se já passou a aula e não tem evolução colocar cor de erro
                    margin: EdgeInsets.all(1),
                    padding: EdgeInsets.all(5),
                    onTap: () async {
                      final result = await Navigator.of(context)
                          .pushNamed(Rotas.EVOLUCAO_FORM, arguments: null);
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
    );
  }
}
