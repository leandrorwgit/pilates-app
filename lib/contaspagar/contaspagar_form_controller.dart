import 'package:app_pilates/utils/formatos.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../models/contaspagar.dart';
import 'contaspagar_repository.dart';

class ContasPagarFormController {
  final _repository = ContasPagarRepository();
  int? idContasPagar;
  final descricaoController = TextEditingController(text: '');
  final diaVencimentoController = TextEditingController(text: '');
  final valorController = TextEditingController(text: '');
  bool ativo = true;
  final formaPagamentoItens = ['Boleto', 'Pix', 'Dinheiro', 'Depósito', 'DOC'];
  String formaPagamento = 'Boleto';
  var carregando = RxNotifier<bool>(false);

  void carregar(ContasPagar? contasPagar) {
    if (contasPagar != null) {
      idContasPagar = contasPagar.id;
      descricaoController.text = contasPagar.descricao ?? '';
      diaVencimentoController.text = contasPagar.diaVencimento != null ? contasPagar.diaVencimento.toString() : '';
      valorController.text = contasPagar.valor != null ? Formatos.moedaReal.format(contasPagar.valor) : '';
      formaPagamento = contasPagar.formaPagamento ?? 'Boleto';
      ativo = contasPagar.ativo ?? false;       
    }
  }

  Future<ContasPagar> persistir() async {
    try {
      carregando.value = true;
      ContasPagar contasPagar = ContasPagar();    
      contasPagar.descricao = descricaoController.text;
      contasPagar.diaVencimento = int.tryParse(diaVencimentoController.text) ?? 0;
      contasPagar.valor = double.tryParse(valorController.text.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.')) ?? 0;
      contasPagar.formaPagamento = formaPagamento;
      contasPagar.ativo = ativo;
      ContasPagar contasPagarRetorno;  
      if (idContasPagar == null) {
        contasPagarRetorno = await _repository.inserir(contasPagar);
      } else {
        contasPagar.id = idContasPagar;
        contasPagarRetorno = await _repository.atualizar(contasPagar);
      }  
      return contasPagarRetorno;
    } finally {
      carregando.value = false;
    }
  }

  void dispose() {
    descricaoController.dispose();
    diaVencimentoController.dispose();
    valorController.dispose();
  }
}
