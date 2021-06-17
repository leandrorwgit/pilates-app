import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../utils/formatos.dart';
import '../models/aluno.dart';
import 'aluno_repository.dart';

class AlunoFormController {
  final _repository = AlunoRepository();
  int? idAluno;
  final nomeController = TextEditingController(text: '');
  final idadeController = TextEditingController(text: '');
  final dataNascimentoController = TextEditingController(text: '');
  final profissaoController = TextEditingController(text: '');
  final celularController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final objetivosPilatesController = TextEditingController(text: '');
  final queixasController = TextEditingController(text: '');
  final diaPagamentoController = TextEditingController(text: '');
  List<bool> aulaDiaSelecionado = [false, false, false, false, false, false];
  List<String?> aulaHorarioInicioDiaSelecionado = [null, null, null, null, null, null];
  final aulaDuracaoController = TextEditingController(text: '');
  bool ativo = true;
  final formaPagamentoItens = ['Pix', 'Dinheiro', 'Depósito', 'DOC'];
  String formaPagamento = 'Pix';
  var carregando = RxNotifier<bool>(false);

  void carregar(Aluno? aluno) {
    if (aluno != null) {
      idAluno = aluno.id;
      nomeController.text = aluno.nome ?? '';
      idadeController.text = aluno.idade != null ? aluno.idade.toString() : '';
      dataNascimentoController.text = aluno.dataNascimento != null ? Formatos.data.format(aluno.dataNascimento!) : '';
      profissaoController.text = aluno.profissao ?? '';
      celularController.text = aluno.celular ?? '';
      emailController.text = aluno.email ?? '';
      objetivosPilatesController.text = aluno.objetivosPilates ?? '';
      queixasController.text = aluno.queixas ?? '';
      formaPagamento = aluno.formaPagamento ?? 'Pix';
      diaPagamentoController.text = aluno.diaPagamento != null ? aluno.diaPagamento.toString() : '';
      aulaDiaSelecionado[0] = aluno.aulaSeg ?? false;
      aulaDiaSelecionado[1] = aluno.aulaTer ?? false;
      aulaDiaSelecionado[2] = aluno.aulaQua ?? false;
      aulaDiaSelecionado[3] = aluno.aulaQui ?? false;
      aulaDiaSelecionado[4] = aluno.aulaSex ?? false;
      aulaDiaSelecionado[5] = aluno.aulaSab ?? false;
      aulaHorarioInicioDiaSelecionado[0] = aluno.aulaHorarioInicioSeg;
      aulaHorarioInicioDiaSelecionado[1] = aluno.aulaHorarioInicioTer;
      aulaHorarioInicioDiaSelecionado[2] = aluno.aulaHorarioInicioQua;
      aulaHorarioInicioDiaSelecionado[3] = aluno.aulaHorarioInicioQui;
      aulaHorarioInicioDiaSelecionado[4] = aluno.aulaHorarioInicioSex;
      aulaHorarioInicioDiaSelecionado[5] = aluno.aulaHorarioInicioSab;      
      aulaDuracaoController.text = aluno.aulaDuracao != null ? aluno.aulaDuracao.toString() : '';
      ativo = aluno.ativo ?? false;       
    }
  }

  Future<Aluno> persistir() async {
    try {
      carregando.value = true;
      Aluno aluno = Aluno();    
      aluno.nome = nomeController.text;
      aluno.idade = int.tryParse(idadeController.text) ?? 0;
      aluno.dataNascimento = Formatos.data.parse(dataNascimentoController.text);
      aluno.profissao = profissaoController.text;
      aluno.celular = celularController.text;
      aluno.email = emailController.text;
      aluno.objetivosPilates = objetivosPilatesController.text;
      aluno.queixas = queixasController.text;
      aluno.formaPagamento = formaPagamento;
      aluno.diaPagamento = int.tryParse(diaPagamentoController.text) ?? 0;
      aluno.aulaSeg = aulaDiaSelecionado[0];
      aluno.aulaTer = aulaDiaSelecionado[1];
      aluno.aulaQua = aulaDiaSelecionado[2];
      aluno.aulaQui = aulaDiaSelecionado[3];
      aluno.aulaSex = aulaDiaSelecionado[4];
      aluno.aulaSab = aulaDiaSelecionado[5];
      aluno.aulaHorarioInicioSeg = aulaHorarioInicioDiaSelecionado[0];
      aluno.aulaHorarioInicioTer = aulaHorarioInicioDiaSelecionado[1];
      aluno.aulaHorarioInicioQua = aulaHorarioInicioDiaSelecionado[2];
      aluno.aulaHorarioInicioQui = aulaHorarioInicioDiaSelecionado[3];
      aluno.aulaHorarioInicioSex = aulaHorarioInicioDiaSelecionado[4];
      aluno.aulaHorarioInicioSab = aulaHorarioInicioDiaSelecionado[5];      
      aluno.aulaDuracao = int.tryParse(aulaDuracaoController.text) ?? 0;
      aluno.ativo = ativo;
      Aluno alunoRetorno;  
      if (idAluno == null) {
        alunoRetorno = await _repository.inserir(aluno);
      } else {
        aluno.id = idAluno;
        alunoRetorno = await _repository.atualizar(aluno);
      }  
      return alunoRetorno;
    } finally {
      carregando.value = false;
    }
  }

  void dispose() {
    nomeController.dispose();
    idadeController.dispose();
    dataNascimentoController.dispose();
    profissaoController.dispose();
    celularController.dispose();
    emailController.dispose();
    objetivosPilatesController.dispose();
    queixasController.dispose();
    diaPagamentoController.dispose();
    aulaDuracaoController.dispose();
  }
}
