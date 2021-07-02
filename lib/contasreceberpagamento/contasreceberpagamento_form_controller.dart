import '../aluno/aluno_repository.dart';
import '../models/aluno.dart';
import '../models/contasreceberpagamento.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter/material.dart';

import '../utils/formatos.dart';
import 'contasreceberpagamento_repository.dart';

class ContasReceberPagamentoFormController {
  final _repository = ContasReceberPagamentoRepository();
  final _repositoryAluno = AlunoRepository();
  var contasReceberPagamento = ContasReceberPagamento();
  var alunoSelecionado = Aluno();
  int? idContasReceberPagamento;
  final alunoController = TextEditingController(text: '');
  final alunoValorPagamentoController = TextEditingController(text: '');
  final dataPagamentoController = TextEditingController(text: '');
  final valorPagoController = TextEditingController(text: '');
  final formaPagamentoItens = ['Boleto', 'Pix', 'Dinheiro', 'Depósito', 'DOC'];
  String formaPagamento = 'Pix';
  var carregando = RxNotifier<bool>(false);

  void carregar(ContasReceberPagamento? contasReceberPagamento) {
    if (contasReceberPagamento != null) {
      this.contasReceberPagamento = contasReceberPagamento;
      this.alunoSelecionado = contasReceberPagamento.aluno!;
      idContasReceberPagamento = contasReceberPagamento.id;
      alunoController.text = alunoSelecionado.nome!;
      alunoValorPagamentoController.text = (alunoSelecionado.valorPagamento != null ? 'Valor: '+Formatos.moedaReal.format(alunoSelecionado.valorPagamento) : '');
      dataPagamentoController.text = Formatos.data
          .format(contasReceberPagamento.dataPagamento != null ? contasReceberPagamento.dataPagamento! : DateTime.now());
      valorPagoController.text = contasReceberPagamento.valorPago != null ? Formatos.moedaReal.format(contasReceberPagamento.valorPago) : '';
      formaPagamento = contasReceberPagamento.formaPagamento ?? 'Pix';
    } else {
      dataPagamentoController.text = Formatos.data.format(DateTime.now());
    }
  }

  Future<ContasReceberPagamento> persistir() async {
    try {
      carregando.value = true;    
      contasReceberPagamento.aluno = alunoSelecionado;
      contasReceberPagamento.dataPagamento = Formatos.data.parse(dataPagamentoController.text);
      contasReceberPagamento.valorPago = double.tryParse(valorPagoController.text.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.')) ?? 0;
      contasReceberPagamento.formaPagamento = formaPagamento;
      ContasReceberPagamento contasReceberPagamentoRetorno;  
      if (idContasReceberPagamento == null) {
        contasReceberPagamentoRetorno = await _repository.inserir(contasReceberPagamento);
      } else {
        contasReceberPagamento.id = idContasReceberPagamento;
        contasReceberPagamentoRetorno = await _repository.atualizar(contasReceberPagamento);
      }  
      return contasReceberPagamentoRetorno;
    } finally {
      carregando.value = false;
    }
  }

  Future<List<Aluno>> listarAlunos(String nome) {
    return _repositoryAluno.listar(nome, true);
  }

  Future<Aluno> buscarAluno(int idAluno) {
    return _repositoryAluno.buscar(idAluno);
  }

  Future<ContasReceberPagamento> buscarPorId(int idContasReceberPagamento) {
    return _repository.buscar(idContasReceberPagamento);
  }
    
  void dispose() {
    alunoController.dispose();
    alunoValorPagamentoController.dispose();
    dataPagamentoController.dispose();
    valorPagoController.dispose();
  }
}
