import 'package:intl/intl.dart';

class Formatos {
  static final data = DateFormat('dd/MM/yyyy');

  static String adicionaZeroEsquerda(int number) =>
      (number < 10 ? '0' : '') + number.toString();
}
