import '../configuracao/configuracao_repository.dart';
import '../models/usuario.dart';

import '../models/configuracao.dart';

class Sessao {
  static Configuracao? _configuracao;
  static Usuario? _usuario;

  static Future<Configuracao?> getConfiguracaoAsync() async {
    if (_configuracao == null) {
      List<Configuracao> config = await ConfiguracaoRepository().listar();
      if (config.isNotEmpty)
        _configuracao = config.first;
      else
        _configuracao = null;
    }
    return _configuracao;
  }

  static Configuracao getConfiguracaoSync() {
    return _configuracao ?? Configuracao();
  }

  // TODO: Fazer repository do usuario (FAZER BUSCA POR EMAIL)
  //   
  static Future<Usuario?> getUsuarioAsync(String email) async {
  }

  static Usuario getUsuarioSync() {
    return _usuario ?? Usuario();
  }

  static void atualizaConfiguracao(Configuracao config) {
    _configuracao = config;
  }
}