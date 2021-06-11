import 'package:app_pilates/models/agenda_retorno.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter/material.dart';

import '../aluno/aluno_repository.dart';
import '../models/aluno.dart';
import '../utils/formatos.dart';

import '../models/agendamento.dart';
import 'agendamento_repository.dart';

class ReAgendamentoFormController {
  final _repository = AgendamentoRepository();
  final _repositoryAlunos = AlunoRepository();
  var agendamento = Agendamento();
  var alunoSelecionado = Aluno();
  final alunoController = TextEditingController(text: '');
  final dataHoraInicioController = TextEditingController(text: '');
  final duracaoController = TextEditingController(text: '');
  final tituloController = TextEditingController(text: '');
  final descricaoController = TextEditingController(text: '');
  var carregando = RxNotifier<bool>(false);

  Future<void> carregar(AgendaRetorno agendaRetorno) async {
    try {
      carregando.value = true;
      this.alunoSelecionado = await _repositoryAlunos.buscar(agendaRetorno.idAluno!);
      this.agendamento.aluno = alunoSelecionado;
      alunoController.text = agendamento.aluno?.nome ?? '';
      if (agendaRetorno.dia != null && agendaRetorno.horaIni != null) {
        String strDataYMDHora = agendaRetorno.dia! + ' ' + agendaRetorno.horaIni!;
        DateTime dataYMDHora = Formatos.dataYMDHora.parse(strDataYMDHora);
        dataHoraInicioController.text = Formatos.dataHora.format(dataYMDHora);
      }
      tituloController.text = 'Reag. '+(alunoController.text.split(' ')[0]);
      descricaoController.text = 'Reagendamento'; 
    } finally {
      carregando.value = false;
    }         
  }

  Future<Agendamento> persistir() async {
    try {
      carregando.value = true;  
      // Cria agendamento para cancelar a agenda normal
      Agendamento agendamentoCanc = Agendamento();
      agendamentoCanc.aluno = agendamento.aluno;
      agendamentoCanc.dataHoraInicio = Formatos.dataHora.parse(dataHoraInicioController.text);
      agendamentoCanc.duracao = int.tryParse(duracaoController.text) ?? 0;
      agendamentoCanc.titulo = 'Cancelamento';
      agendamentoCanc.descricao = 'Cancelamento efetuado no dia '+Formatos.dataHora.format(DateTime.now())+'. [TituloRef: '+tituloController.text+']';
      agendamentoCanc.situacao = 'CANCELADO';
      await _repository.inserir(agendamentoCanc);   

      // Cria Agendamento novo  
      agendamento.dataHoraInicio = Formatos.dataHora.parse(dataHoraInicioController.text);
      agendamento.duracao = int.tryParse(duracaoController.text) ?? 0;
      agendamento.titulo = tituloController.text;
      agendamento.descricao = descricaoController.text;
      agendamento.situacao = 'CRIADO';
      return await _repository.inserir(agendamento);      
    } finally {
      carregando.value = false;
    }
  }
    
  void dispose() {
    alunoController.dispose();
    dataHoraInicioController.dispose();
    duracaoController.dispose();
    tituloController.dispose();
    descricaoController.dispose();
  }
}
