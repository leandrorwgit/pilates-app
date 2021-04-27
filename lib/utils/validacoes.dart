import 'package:app_pilates/utils/formatos.dart';

class Validacoes {
  static String? validarCampoObrigatorio(String? valor, String mensagem) {
    return (valor == null || valor.trim().isEmpty) ? mensagem : null;
  }

  static String? validarData(String? valor, String mensagem) {
    if (valor!.isEmpty)
      return mensagem;
    if (valor.length != 10)
      return mensagem;
    try {
      Formatos.data.parse(valor);
      return null;
    } catch (e) {
      return mensagem;
    }
  }
}
