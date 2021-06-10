import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter/material.dart';

import '../aluno/aluno_repository.dart';
import '../models/aluno.dart';
import '../utils/formatos.dart';

import '../models/agendamento.dart';
import '../agendamento/agendamento_repository.dart';

class AgendamentoFormController {
  final _repository = AgendamentoRepository();
  final _repositoryAlunos = AlunoRepository();
  var agendamento = Agendamento();
  var alunoSelecionado = Aluno();
  int? idAgendamento;
  final alunoController = TextEditingController(text: '');
  final dataHoraInicioController = TextEditingController(text: '');
  final duracaoController = TextEditingController(text: '');
  final tituloController = TextEditingController(text: '');
  final descricaoController = TextEditingController(text: '');
  final situacaoItens = ['CRIADO', 'CANCELADO', 'CONCLUIDO'];
  String situacao = 'CRIADO';
  var carregando = RxNotifier<bool>(false);

  void carregar(Agendamento? agendamento) {
    if (agendamento != null) {
      this.agendamento = agendamento;
      this.alunoSelecionado = agendamento.aluno!;
      idAgendamento = agendamento.id;
      alunoController.text = agendamento.aluno?.nome ?? '';
      dataHoraInicioController.text = Formatos.dataHora
          .format(agendamento.dataHoraInicio != null ? agendamento.dataHoraInicio! : DateTime.now());
      duracaoController.text = agendamento.duracao != null ? agendamento.duracao.toString() : '';
      tituloController.text = agendamento.titulo ?? '';
      descricaoController.text = agendamento.descricao ?? '';
      situacao = agendamento.situacao ?? 'CRIADO';
    } else {
      dataHoraInicioController.text = Formatos.dataHora.format(DateTime.now());
    }
  }

  Future<Agendamento> persistir() async {
    try {
      carregando.value = true;    
      agendamento.aluno = alunoSelecionado;
      agendamento.dataHoraInicio = Formatos.dataHora.parse(dataHoraInicioController.text);
      agendamento.duracao = int.tryParse(duracaoController.text) ?? 0;
      agendamento.titulo = tituloController.text;
      agendamento.descricao = descricaoController.text;
      agendamento.situacao = situacao;
      Agendamento agendamentoRetorno;  
      if (idAgendamento == null) {
        agendamentoRetorno = await _repository.inserir(agendamento);
      } else {
        agendamento.id = idAgendamento;
        agendamentoRetorno = await _repository.atualizar(agendamento);
      }  
      return agendamentoRetorno;
    } finally {
      carregando.value = false;
    }
  }

  Future<List<Aluno>> buscarAlunos(String nome) async {
    return _repositoryAlunos.listar(nome, true);
  }
    
  void dispose() {
    alunoController.dispose();
    dataHoraInicioController.dispose();
    duracaoController.dispose();
    tituloController.dispose();
    descricaoController.dispose();
  }
}
