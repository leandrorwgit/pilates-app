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
  final aulaHorarioIniController = TextEditingController(text: '');
  final aulaHorarioFimController = TextEditingController(text: '');
  bool ativo = true;
  final formaPagamentoItens = ['Pix', 'Dinheiro', 'Depósito', 'DOC'];
  String formaPagamento = 'Pix';
  var carregando = RxNotifier<int>(0);

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
      aulaHorarioIniController.text = aluno.aulaHorarioIni ?? '';
      aulaHorarioFimController.text = aluno.aulaHorarioFim ?? '';
      ativo = aluno.ativo ?? false;       
    }
  }

  Future<Aluno> persistir() async {
    try {
      carregando.value = 1;
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
      aluno.aulaHorarioIni = aulaHorarioIniController.text;
      aluno.aulaHorarioFim = aulaHorarioFimController.text;
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
      carregando.value = 0;
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
    aulaHorarioIniController.dispose();
    aulaHorarioFimController.dispose();
  }
}
