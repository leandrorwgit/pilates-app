import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../models/configuracao.dart';
import 'configuracao_repository.dart';

class ConfiguracaoFormController {
  final _repository = ConfiguracaoRepository();
  int? idConfiguracao;
  final duracaoPadraoAulaController = TextEditingController(text: '');
  var carregando = RxNotifier<bool>(false);

  void carregar(Configuracao? configuracao) {
    if (configuracao != null) {
      idConfiguracao = configuracao.id;
      duracaoPadraoAulaController.text = configuracao.duracaoPadraoAula != null ? configuracao.duracaoPadraoAula.toString() : '';
    }
  }

  Future<Configuracao> persistir() async {
    try {
      carregando.value = true;
      Configuracao configuracao = Configuracao();    
      configuracao.duracaoPadraoAula = int.tryParse(duracaoPadraoAulaController.text) ?? 0;
      Configuracao configuracaoRetorno;  
      if (idConfiguracao == null) {
        configuracaoRetorno = await _repository.inserir(configuracao);
      } else {
        configuracao.id = idConfiguracao;
        configuracaoRetorno = await _repository.atualizar(configuracao);
      }  
      return configuracaoRetorno;
    } finally {
      carregando.value = false;
    }
  }

  void dispose() {
    duracaoPadraoAulaController.dispose();
  }
}
