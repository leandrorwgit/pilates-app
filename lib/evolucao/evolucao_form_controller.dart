import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter/material.dart';

import '../aluno/aluno_repository.dart';
import '../models/aluno.dart';
import '../utils/formatos.dart';

import '../models/evolucao.dart';
import 'evolucao_repository.dart';

class EvolucaoFormController {
  final _repository = EvolucaoRepository();
  final _repositoryAlunos = AlunoRepository();
  var evolucao = Evolucao();
  var alunoSelecionado = Aluno();
  int? idEvolucao;
  final alunoController = TextEditingController(text: '');
  final dataController = TextEditingController(text: '');
  final comoChegouController = TextEditingController(text: '');
  final condutasUtilizadasController = TextEditingController(text: '');
  final comoSaiuController = TextEditingController(text: '');
  final orientacoesDomiciliaresController = TextEditingController(text: '');
  final aparelhosItens = [
    'Cadillac',
    'Reformer',
    'Chair',
    'Barrel',
    'Mat'
  ];
  List<bool> aparelhosSelecionados = [false, false, false, false, false];
  var carregando = RxNotifier<int>(0);

  List<bool> aparelhosToList(String? aparelhosUtilizados) {
    final retorno = [false, false, false, false, false];
    if (aparelhosUtilizados != null && aparelhosUtilizados.isNotEmpty) {
      aparelhosUtilizados.split(';').forEach((element) {
        var indexOf = aparelhosItens.indexOf(element);
        if (indexOf >= 0) retorno[indexOf] = true;
      });
    }
    return retorno;
  }

  String? aparelhosToString(List<bool> aparelhosSelecionados) {
    String retorno = '';
    for (int i = 0; i < aparelhosSelecionados.length; i++) {
      if (aparelhosSelecionados[i] == true) {
        retorno = retorno + aparelhosItens[i] + ';';
      }
    }
    if (retorno.length > 0) 
      retorno = retorno.substring(0, retorno.length - 1);
    return retorno;
  }

  void carregar(Evolucao? evolucao) {
    if (evolucao != null) {
      this.evolucao = evolucao;
      this.alunoSelecionado = evolucao.aluno!;
      idEvolucao = evolucao.id;
      alunoController.text = evolucao.aluno?.nome ?? '';
      dataController.text = Formatos.data
          .format(evolucao.data != null ? evolucao.data! : DateTime.now());
      comoChegouController.text = evolucao.comoChegou ?? '';
      condutasUtilizadasController.text = evolucao.condutasUtilizadas ?? '';
      aparelhosSelecionados = aparelhosToList(evolucao.aparelhosUtilizados);
      comoSaiuController.text = evolucao.comoSaiu ?? '';
      orientacoesDomiciliaresController.text =
          evolucao.orientacoesDomiciliares ?? '';
    } else {
      dataController.text = Formatos.data.format(DateTime.now());
      alunoSelecionado.id = 1;
    }
  }

  Future<Evolucao> persistir() async {
    try {
      carregando.value = 1;    
      evolucao.aluno = alunoSelecionado;
      evolucao.data = Formatos.data.parse(dataController.text);
      evolucao.comoChegou = comoChegouController.text;
      evolucao.condutasUtilizadas = condutasUtilizadasController.text;
      evolucao.aparelhosUtilizados = aparelhosToString(aparelhosSelecionados);
      evolucao.comoSaiu = comoSaiuController.text;
      evolucao.orientacoesDomiciliares = orientacoesDomiciliaresController.text;
      Evolucao evolucaoRetorno;  
      if (idEvolucao == null) {
        evolucaoRetorno = await _repository.inserir(evolucao);
      } else {
        evolucao.id = idEvolucao;
        evolucaoRetorno = await _repository.atualizar(evolucao);
      }  
      return evolucaoRetorno;
    } finally {
      carregando.value = 0;
    }
  }

  Future<List<Aluno>> buscarAlunos(String nome) async {
    return _repositoryAlunos.buscar(nome, null);
  }
    
  void dispose() {
    alunoController.dispose();
    dataController.dispose();
    comoChegouController.dispose();
    condutasUtilizadasController.dispose();
    comoSaiuController.dispose();
    orientacoesDomiciliaresController.dispose();
  }
}
