import 'dart:async';
import 'dart:math';
import 'package:app_pilates/aluno/aluno_repository.dart';
import 'package:app_pilates/utils/componentes.dart';

import '../models/diasemana_retorno.dart';
import '../utils/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoAulaSemana extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GraficoAulaSemanaState();
}

class GraficoAulaSemanaState extends State<GraficoAulaSemana> {
  late final AlunoRepository _repository;
  late Future<DiaSemanaRetorno?> _diaSemanaRetornoFuture;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _repository = new AlunoRepository();
    _diaSemanaRetornoFuture = _repository.listarPorDiaSemana();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this._diaSemanaRetornoFuture,
        builder:
            (BuildContext context, AsyncSnapshot<DiaSemanaRetorno?> snapshot) {
          if (snapshot.hasError) {
            return Componentes.erroRest(snapshot);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            DiaSemanaRetorno? diaRetorno = snapshot.data;
            int maximo = [
              int.tryParse(diaRetorno!.totalAulaSeg!) ?? 0,
              int.tryParse(diaRetorno.totalAulaTer!) ?? 0,
              int.tryParse(diaRetorno.totalAulaQua!) ?? 0,
              int.tryParse(diaRetorno.totalAulaQui!) ?? 0,
              int.tryParse(diaRetorno.totalAulaSex!) ?? 0,
              int.tryParse(diaRetorno.totalAulaSab!) ?? 0
            ].reduce(max);
            
            return AspectRatio(
              aspectRatio: 1.2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  color: const Color.fromARGB(1, 0, 0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Aulas por dia da semana',
                          style: TextStyle(
                              color: AppColors.texto,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              mainBarData(diaRetorno, maximo.toDouble()),
                              swapAnimationDuration: animDuration,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  BarChartData mainBarData(DiaSemanaRetorno? diaRetorno, double maximo) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Segunda';
                  break;
                case 1:
                  weekDay = 'Terça';
                  break;
                case 2:
                  weekDay = 'Quarta';
                  break;
                case 3:
                  weekDay = 'Quinta';
                  break;
                case 4:
                  weekDay = 'Sexta';
                  break;
                case 5:
                  weekDay = 'Sábado';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y).toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'S';
              case 1:
                return 'T';
              case 2:
                return 'Q';
              case 3:
                return 'Q';
              case 4:
                return 'S';
              case 5:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(diaRetorno, maximo),
    );
  }

  List<BarChartGroupData> showingGroups(DiaSemanaRetorno? diaRetorno, double maximo) => List.generate(6, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, double.tryParse(diaRetorno!.totalAulaSeg!) ?? 0, maximo);
          case 1:
            return makeGroupData(1, double.tryParse(diaRetorno!.totalAulaTer!) ?? 0, maximo);
          case 2:
            return makeGroupData(2, double.tryParse(diaRetorno!.totalAulaQua!) ?? 0, maximo);
          case 3:
            return makeGroupData(3, double.tryParse(diaRetorno!.totalAulaQui!) ?? 0, maximo);
          case 4:
            return makeGroupData(4, double.tryParse(diaRetorno!.totalAulaSex!) ?? 0, maximo);
          case 5:
            return makeGroupData(5, double.tryParse(diaRetorno!.totalAulaSab!) ?? 0, maximo);
          default:
            return throw Error();
        }
      });

  BarChartGroupData makeGroupData(int x, double y, double max) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: [Theme.of(context).accentColor],
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: max,
            colors: [Color.fromARGB(20, 255, 255, 255)],
          ),
        ),
      ],
    );
  }
}
