import 'package:intl/intl.dart';

class Formatos {
  static final data = DateFormat('dd/MM/yyyy');
  static final dataHora = DateFormat('dd/MM/yyyy HH:mm');
  static final dataYMD = DateFormat('yyyy-MM-dd');
  static final dataYMDHora = DateFormat('yyyy-MM-dd HH:mm:ss');

  static final moedaReal = NumberFormat.simpleCurrency(locale: "pt_Br");

  static String adicionaZeroEsquerda(int number) =>
      (number < 10 ? '0' : '') + number.toString();

  static String getNomeMes(String mes) {
    if (mes == '1')
      return 'Janeiro';
    else if (mes == '2')
      return 'Fevereiro';
    else if (mes == '3')
      return 'Março';
    else if (mes == '4')
      return 'Abril';
    else if (mes == '5')
      return 'Maio';
    else if (mes == '6')
      return 'Junho';
    else if (mes == '7')
      return 'Julho';
    else if (mes == '8')
      return 'Agosto';
    else if (mes == '9') 
      return 'Setembro';
    else if (mes == '10') 
      return 'Outubro';
    else if (mes == '11') 
      return 'Novembro';
    else if (mes == '12') 
      return 'Dezembro';
    else 
      return '';
  }

  static String getNumeroMes(String nomeMes) {
    if (nomeMes == 'Janeiro')
      return '1';
    else if (nomeMes == 'Fevereiro')
      return '2';
    else if (nomeMes == 'Março')
      return '3';
    else if (nomeMes == 'Abril')
      return '4';
    else if (nomeMes == 'Maio')
      return '5';
    else if (nomeMes == 'Junho')
      return '6';
    else if (nomeMes == 'Julho')
      return '7';
    else if (nomeMes == 'Agosto')
      return '8';
    else if (nomeMes == 'Setembro')
      return '9';
    else if (nomeMes == 'Outubro')
      return '10';
    else if (nomeMes == 'Novembro')
      return '11';
    else if (nomeMes == 'Dezembro')
      return '12';
    else
      return '';
  }

  static List<String> getMeses() {
    return ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
  }
}
