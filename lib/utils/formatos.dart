import 'package:intl/intl.dart';

class Formatos {
  static final data = DateFormat('dd/MM/yyyy');
  static final dataHora = DateFormat('dd/MM/yyyy HH:mm');
  static final dataYMD = DateFormat('yyyy-MM-dd');
  static final dataYMDHora = DateFormat('yyyy-MM-dd HH:mm:ss');

  static String adicionaZeroEsquerda(int number) =>
      (number < 10 ? '0' : '') + number.toString();
}
