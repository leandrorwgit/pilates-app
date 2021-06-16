import '../contaspagar/contaspagar_repository.dart';
import '../models/contaspagar.dart';
import '../models/contaspagarpagamento.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter/material.dart';

import '../utils/formatos.dart';
import 'contaspagarpagamento_repository.dart';

class ContasPagarPagamentoFormController {
  final _repository = ContasPagarPagamentoRepository();
  final _repositoryContasPagar = ContasPagarRepository();
  var contasPagarPagamento = ContasPagarPagamento();
  var contasPagarSelecionada = ContasPagar();
  int? idContasPagarPagamento;
  final contasPagarController = TextEditingController(text: '');
  final contasPagarValorController = TextEditingController(text: '');
  final dataPagamentoController = TextEditingController(text: '');
  final valorPagoController = TextEditingController(text: '');
  final formaPagamentoItens = ['Boleto', 'Pix', 'Dinheiro', 'Depósito', 'DOC'];
  String formaPagamento = 'Boleto';
  var carregando = RxNotifier<bool>(false);

  void carregar(ContasPagarPagamento? contasPagarPagamento) {
    if (contasPagarPagamento != null) {
      this.contasPagarPagamento = contasPagarPagamento;
      this.contasPagarSelecionada = contasPagarPagamento.contasPagar!;
      idContasPagarPagamento = contasPagarPagamento.id;
      contasPagarController.text = contasPagarSelecionada.descricao!;
      contasPagarValorController.text = (contasPagarSelecionada.valor != null ? 'Valor: '+Formatos.moedaReal.format(contasPagarSelecionada.valor) : '');
      dataPagamentoController.text = Formatos.data
          .format(contasPagarPagamento.dataPagamento != null ? contasPagarPagamento.dataPagamento! : DateTime.now());
      valorPagoController.text = contasPagarPagamento.valorPago != null ? Formatos.moedaReal.format(contasPagarPagamento.valorPago) : '';
      formaPagamento = contasPagarPagamento.formaPagamento ?? 'Boleto';
    } else {
      dataPagamentoController.text = Formatos.data.format(DateTime.now());
    }
  }

  Future<ContasPagarPagamento> persistir() async {
    try {
      carregando.value = true;    
      contasPagarPagamento.contasPagar = contasPagarSelecionada;
      contasPagarPagamento.dataPagamento = Formatos.data.parse(dataPagamentoController.text);
      contasPagarPagamento.valorPago = double.tryParse(valorPagoController.text.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.')) ?? 0;
      contasPagarPagamento.formaPagamento = formaPagamento;
      ContasPagarPagamento contasPagarPagamentoRetorno;  
      if (idContasPagarPagamento == null) {
        contasPagarPagamentoRetorno = await _repository.inserir(contasPagarPagamento);
      } else {
        contasPagarPagamento.id = idContasPagarPagamento;
        contasPagarPagamentoRetorno = await _repository.atualizar(contasPagarPagamento);
      }  
      return contasPagarPagamentoRetorno;
    } finally {
      carregando.value = false;
    }
  }

  Future<List<ContasPagar>> listarContasPagar(String descricao) {
    return _repositoryContasPagar.listar(descricao, true);
  }

  Future<ContasPagar> buscarContasPagar(int idContasPagar) {
    return _repositoryContasPagar.buscar(idContasPagar);
  }

  Future<ContasPagarPagamento> buscarPorId(int idContasPagarPagamento) {
    return _repository.buscar(idContasPagarPagamento);
  }
    
  void dispose() {
    contasPagarController.dispose();
    contasPagarValorController.dispose();
    dataPagamentoController.dispose();
    valorPagoController.dispose();
  }
}
