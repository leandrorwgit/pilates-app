import '../login/login_repository.dart';

import '../configuracao/configuracao_repository.dart';
import '../models/usuario.dart';

import '../models/configuracao.dart';

class Sessao {
  static Configuracao? _configuracao;
  static Usuario? _usuario;
  static LoginRepository? _loginRepository;

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
   
  static Future<Usuario?> getUsuarioAsync() async {
    if (_loginRepository == null)
      _loginRepository = LoginRepository();
    _usuario = await _loginRepository?.buscarUsuario();
    return _usuario;
  }

  static Usuario getUsuarioSync() {
    return _usuario ?? Usuario();
  }

  static void atualizaConfiguracao(Configuracao config) {
    _configuracao = config;
  }
}