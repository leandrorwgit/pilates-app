import 'dart:math';

import '../models/aluno.dart';
import '../utils/formatos.dart';
import 'package:flutter/material.dart';

import '../models/evolucao.dart';

class EvolucaoFormController {
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
    'Solo',
    'Mat'
  ];
  List<bool> aparelhosSelecionados = [false, false, false, false, false, false];
  final carregando = false;

  List<bool> aparelhosToList(String? aparelhosUtilizados) {
    final retorno = [false, false, false, false, false, false];
    if (aparelhosUtilizados != null && aparelhosUtilizados.isNotEmpty) {
      aparelhosUtilizados.split(';').forEach((element) {
        var indexOf = aparelhosItens.indexOf(element);
        print(indexOf);
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
    }
  }

  Evolucao persistir() {
    Evolucao evolucao = Evolucao();
    if (idEvolucao == null) {
      evolucao.id = Random().nextInt(100);
      evolucao.aluno = Aluno();
    }
    evolucao.aluno?.nome = alunoController.text;
    evolucao.data = Formatos.data.parse(dataController.text);
    evolucao.comoChegou = comoChegouController.text;
    evolucao.condutasUtilizadas = condutasUtilizadasController.text;
    evolucao.aparelhosUtilizados = aparelhosToString(aparelhosSelecionados);
        evolucao.comoSaiu = comoSaiuController.text;
        evolucao.orientacoesDomiciliares = orientacoesDomiciliaresController.text;
        return evolucao;
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
