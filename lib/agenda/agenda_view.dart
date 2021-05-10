import 'package:app_pilates/components/app_drawer.dart';
import 'package:app_pilates/utils/app_colors.dart';
import 'package:app_pilates/utils/formatos.dart';
import 'package:app_pilates/utils/rotas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

class AgendaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return Scaffold(
        appBar: AppBar(
          title: Text('Agenda'),
        ),
        drawer: AppDrawer(),
        body: WeekView(
          initialTime: const HourMinute(hour: 7).atDate(DateTime.now()),
          dates: [
            date.subtract(const Duration(days: 1)),
            date,
            date.add(const Duration(days: 1))
          ],
          events: [
            FlutterWeekViewEvent(
              title: 'An event 1',
              description: 'A description 1',
              start: date.subtract(const Duration(hours: 1)),
              end: date.add(const Duration(hours: 2, minutes: 30)),
              backgroundColor: Theme.of(context).accentColor,
            ),
            FlutterWeekViewEvent(
              title: 'Leandro',
              description: '',
              start: date.add(const Duration(hours: 7)),
              end: date.add(const Duration(hours: 8)),
              backgroundColor: Theme.of(context).accentColor,
              //backgroundColor: Theme.of(context).errorColor, // Se já passou a aula e não tem evolução colocar cor de erro
              margin: EdgeInsets.all(1),
              onTap: () async {
                final result = await Navigator.of(context)
                    .pushNamed(Rotas.EVOLUCAO_FORM, arguments: null);
              },
              eventTextBuilder: (FlutterWeekViewEvent event,
                  BuildContext context,
                  DayView dayView,
                  double height,
                  double width) {
                List<TextSpan> text = [
                  TextSpan(
                    text: event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' ' +
                        dayView.hoursColumnStyle.timeFormatter(
                            HourMinute.fromDateTime(dateTime: event.start)) +
                        ' - ' +
                        dayView.hoursColumnStyle.timeFormatter(
                            HourMinute.fromDateTime(dateTime: event.end)) +
                        '\n',
                  ),
                  TextSpan(
                    text: event.description,
                  ),
                ];

                return RichText(
                  text: TextSpan(
                    children: text,
                    style: event.textStyle,
                  ),
                );
              },
            ),
            FlutterWeekViewEvent(
              title: 'Flávia',
              description: '',
              start: date.add(const Duration(hours: 7)),
              end: date.add(const Duration(hours: 8)),
              backgroundColor: Theme.of(context).accentColor,
              margin: EdgeInsets.all(1),
            ),
            FlutterWeekViewEvent(
              title: 'An event 3',
              description: 'A description 3',
              start: date.add(const Duration(hours: 23, minutes: 30)),
              end: date.add(const Duration(hours: 25, minutes: 30)),
              backgroundColor: Theme.of(context).accentColor,
            ),
          ],
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
        ));
  }
}
